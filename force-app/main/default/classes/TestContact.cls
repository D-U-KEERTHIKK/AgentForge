@IsTest
private class TestContact {

    @IsTest
    static void testInsertContact() {
        User testUser = createTestUser();
        Test.startTest();
        System.runAs(testUser) {
            Contact c = new Contact(
                Email = 'john.doe@example.com'
            );
            insert c;
            
            Assert.isNotNull(c.Id, 'Contact Id should not be null after insert');
        }
        Test.stopTest();
    }

    @IsTest
    static void testUpdateContact() {
        User testUser = createTestUser();
        Test.startTest();
        System.runAs(testUser) {
            Contact c = new Contact(
                Email = 'jane.smith@example.com'
            );
            insert c;
            
            c.Email = 'jane.updated@example.com';
            update c;
            
            Contact updated = [SELECT Email FROM Contact WHERE Id = :c.Id LIMIT 1];
            Assert.areEqual('jane.updated@example.com', updated.Email, 'Email should be updated');
        }
        Test.stopTest();
    }

    @IsTest
    static void testQueryContact() {
        User testUser = createTestUser();
        Test.startTest();
        System.runAs(testUser) {
            Contact c = new Contact(
                Email = 'bob.johnson@example.com'
            );
            insert c;
            
            Contact queried = [SELECT Id, Email FROM Contact WHERE Id = :c.Id LIMIT 1];
            Assert.areEqual('bob.johnson@example.com', queried.Email, 'Email should match queried contact');
        }
        Test.stopTest();
    }

    @IsTest
    static void testDeleteContact() {
        User testUser = createTestUser();
        Test.startTest();
        System.runAs(testUser) {
            Contact c = new Contact(
                Email = 'alice.williams@example.com'
            );
            insert c;
            Id contactId = c.Id;
            
            delete c;
            
            List<Contact> deleted = [SELECT Id FROM Contact WHERE Id = :contactId];
            Assert.areEqual(0, deleted.size(), 'Contact should be deleted');
        }
        Test.stopTest();
    }

    private static User createTestUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1];
        User u = new User(
            Alias = 'testuser',
            Email = 'testuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = p.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            Username = 'testuser' + Crypto.getRandomInteger() + '@example.com'
        );
        insert u;
        return u;
    }
}