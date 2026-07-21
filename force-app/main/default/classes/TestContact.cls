@IsTest
private class TestContact {

    @IsTest
    static void testInsertContact() {
        User testUser = createTestUser();
        System.Test.startTest();
        System.runAs(testUser) {
            Contact c = new Contact(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@example.com',
                Phone = '1234567890'
            );
            insert c;
            
            Contact retrievedContact = [SELECT Id, FirstName, LastName FROM Contact WHERE Id = :c.Id];
            System.assertNotEquals(null, retrievedContact);
            System.assertEquals('John', retrievedContact.FirstName);
        }
        System.Test.stopTest();
    }

    @IsTest
    static void testUpdateContact() {
        User testUser = createTestUser();
        System.Test.startTest();
        System.runAs(testUser) {
            Contact c = new Contact(
                FirstName = 'Jane',
                LastName = 'Smith',
                Email = 'jane.smith@example.com'
            );
            insert c;
            
            c.Phone = '9876543210';
            update c;
            
            Contact retrievedContact = [SELECT Id, Phone FROM Contact WHERE Id = :c.Id];
            System.assertEquals('9876543210', retrievedContact.Phone);
        }
        System.Test.stopTest();
    }

    @IsTest
    static void testDeleteContact() {
        User testUser = createTestUser();
        System.Test.startTest();
        System.runAs(testUser) {
            Contact c = new Contact(
                FirstName = 'Bob',
                LastName = 'Johnson',
                Email = 'bob.johnson@example.com'
            );
            insert c;
            Id contactId = c.Id;
            
            delete c;
            
            List<Contact> deletedContacts = [SELECT Id FROM Contact WHERE Id = :contactId];
            System.assertEquals(0, deletedContacts.size());
        }
        System.Test.stopTest();
    }

    @IsTest
    static void testContactValidation() {
        User testUser = createTestUser();
        System.Test.startTest();
        System.runAs(testUser) {
            Contact c = new Contact(LastName = 'TestContact');
            insert c;
            
            Contact retrievedContact = [SELECT Id, LastName FROM Contact WHERE Id = :c.Id];
            System.assertNotEquals(null, retrievedContact.LastName);
        }
        System.Test.stopTest();
    }

    private static User createTestUser() {
        User u = new User(
            Alias = 'testuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser@example.com'
        );
        insert u;
        return u;
    }
}
