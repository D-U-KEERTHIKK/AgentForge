@IsTest
public class TestContact {
    @IsTest
    static void testContactCreation() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            Contact contact = new Contact(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@example.com'
            );
            
            System.Test.startTest();
            insert contact;
            System.Test.stopTest();
            
            Contact insertedContact = [SELECT Id, Email FROM Contact WHERE Id = :contact.Id];
            Assert.isNotNull(insertedContact);
            Assert.areEqual('john.doe@example.com', insertedContact.Email);
        }
    }
    
    @IsTest
    static void testContactUpdate() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            Contact contact = new Contact(
                FirstName = 'Jane',
                LastName = 'Smith',
                Email = 'jane.smith@example.com'
            );
            insert contact;
            
            contact.Email = 'jane.smith.updated@example.com';
            
            System.Test.startTest();
            update contact;
            System.Test.stopTest();
            
            Contact updatedContact = [SELECT Id, Email FROM Contact WHERE Id = :contact.Id];
            Assert.areEqual('jane.smith.updated@example.com', updatedContact.Email);
        }
    }
    
    @IsTest
    static void testContactDelete() {
        User testUser = createTestUser();
        
        System.runAs(testUser) {
            Contact contact = new Contact(
                FirstName = 'Bob',
                LastName = 'Johnson',
                Email = 'bob.johnson@example.com'
            );
            insert contact;
            Id contactId = contact.Id;
            
            System.Test.startTest();
            delete contact;
            System.Test.stopTest();
            
            List<Contact> deletedContacts = [SELECT Id FROM Contact WHERE Id = :contactId];
            Assert.areEqual(0, deletedContacts.size());
        }
    }
    
    private static User createTestUser() {
        Profile standardProfile = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User testUser = new User(
            FirstName = 'Test',
            LastName = 'User',
            Email = 'testuser@example.com',
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