@IsTest
public class TestContact {
  
  @IsTest
  public static void testContactCreation() {
    User testUser = createTestUser();
    
    System.runAs(testUser) {
      Contact testContact = new Contact(
        FirstName = 'John',
        LastName = 'Doe',
        Email = 'john.doe@example.com',
        Phone = '555-0100'
      );
      
      Test.startTest();
      insert testContact;
      Test.stopTest();
      
      Assert.isNotNull(testContact.Id, 'Contact ID should not be null after insert');
      
      Contact retrievedContact = [SELECT Id, Email, Phone FROM Contact WHERE Id = :testContact.Id LIMIT 1];
      Assert.areEqual('john.doe@example.com', retrievedContact.Email, 'Email should match');
      Assert.areEqual('555-0100', retrievedContact.Phone, 'Phone should match');
    }
  }

  @IsTest
  public static void testContactUpdate() {
    User testUser = createTestUser();
    
    System.runAs(testUser) {
      Contact testContact = new Contact(
        FirstName = 'Jane',
        LastName = 'Smith',
        Email = 'jane.smith@example.com'
      );
      insert testContact;
      
      Test.startTest();
      testContact.Phone = '555-0200';
      testContact.Email = 'jane.smith.updated@example.com';
      update testContact;
      Test.stopTest();
      
      Contact updatedContact = [SELECT Id, Phone, Email FROM Contact WHERE Id = :testContact.Id LIMIT 1];
      Assert.areEqual('555-0200', updatedContact.Phone, 'Phone should be updated');
      Assert.areEqual('jane.smith.updated@example.com', updatedContact.Email, 'Email should be updated');
    }
  }

  @IsTest
  public static void testContactQuery() {
    User testUser = createTestUser();
    
    System.runAs(testUser) {
      Contact contact1 = new Contact(
        FirstName = 'Alice',
        LastName = 'Johnson',
        Email = 'alice@example.com'
      );
      Contact contact2 = new Contact(
        FirstName = 'Bob',
        LastName = 'Williams',
        Email = 'bob@example.com'
      );
      
      Test.startTest();
      insert new List<Contact> { contact1, contact2 };
      Test.stopTest();
      
      List<Contact> queriedContacts = [SELECT Id, Email FROM Contact WHERE Email IN ('alice@example.com', 'bob@example.com') ORDER BY Email ASC];
      Assert.areEqual(2, queriedContacts.size(), 'Should return 2 contacts');
    }
  }

  @IsTest
  public static void testContactDelete() {
    User testUser = createTestUser();
    
    System.runAs(testUser) {
      Contact testContact = new Contact(
        FirstName = 'David',
        LastName = 'Brown',
        Email = 'david.brown@example.com'
      );
      insert testContact;
      String contactId = testContact.Id;
      
      Test.startTest();
      delete testContact;
      Test.stopTest();
      
      List<Contact> deletedContacts = [SELECT Id FROM Contact WHERE Id = :contactId];
      Assert.areEqual(0, deletedContacts.size(), 'Contact should be deleted');
    }
  }

  @IsTest
  public static void testContactBulkInsert() {
    User testUser = createTestUser();
    
    System.runAs(testUser) {
      List<Contact> contactsToInsert = new List<Contact>();
      for (Integer i = 0; i < 100; i++) {
        contactsToInsert.add(new Contact(
          FirstName = 'Bulk' + i,
          LastName = 'Contact' + i,
          Email = 'bulk' + i + '@example.com'
        ));
      }
      
      Test.startTest();
      insert contactsToInsert;
      Test.stopTest();
      
      List<Contact> insertedContacts = [SELECT Id FROM Contact WHERE Email LIKE 'bulk%@example.com'];
      Assert.areEqual(100, insertedContacts.size(), 'Should have inserted 100 contacts');
    }
  }

  /**
   * Helper method to create a test user with minimal required fields.
   * @return User test user instance
   */
  private static User createTestUser() {
    Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
    
    User testUser = new User(
      FirstName = 'Test',
      LastName = 'User',
      Email = 'testuser' + System.now().getTime() + '@example.com',
      Username = 'testuser' + System.now().getTime() + '@example.com',
      ProfileId = standardProfile.Id,
      Alias = 'tuser',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US'
    );
    
    insert testUser;
    return testUser;
  }
}