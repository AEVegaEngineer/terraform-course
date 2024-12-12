# To connect with the databse from the instance

### provision the instance and the database

Take note of the instance's public ip address and the database endpoint from the output.

### Connect to the instance via ssh

`ssh -i ~/.ssh/mykey -l ubuntu <>`

### Upgrade the instance to the latest ubuntu version

Follow the steps here: https://ubuntu.com/server/docs/how-to-upgrade-your-release

`sudo apt update`

`sudo apt upgrade`

`sudo do-release-upgrade`

### Install the postgresql client

`sudo apt install postgresql-client`

### Connect to the database

Take the host and port from the output of the database endpoint. The database name is "topinion" from the rds.tf file.

`psql -h postgresql.clqgcwuwsccy.eu-west-1.rds.amazonaws.com -p 5432 -U root -d topinion`

This will prompt you for the password. The password is the one you set in the RDS_PASSWORD variable in the vars.tf file.

### Test the database

1. List all databases:

```
\l
```

2. Create a test table:

```
CREATE TABLE test_table ( id SERIAL PRIMARY KEY, name VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP );
```

3. Insert some data:

```
INSERT INTO test_table (name) VALUES ('Test 1'), ('Test 2'), ('Test 3');
```

4. Query the data:

```
SELECT * FROM test_table;
```

5. Update a record:

```
UPDATE test_table SET name = 'Updated Test' WHERE id = 1;
```

6. Delete a record:

```
DELETE FROM test_table WHERE id = 3;
```

7. Test a simple join by creating another table and joining it:

```
CREATE TABLE test_table_2 ( id SERIAL PRIMARY KEY, test_id INTEGER REFERENCES test_table(id),  description TEXT);
INSERT INTO test_table_2 (test_id, description) VALUES (1, 'Description for Test 1'), (2, 'Description for Test 2');
SELECT t1.name, t2.description FROM test_table t1 JOIN test_table_2 t2 ON t1.id = t2.test_id;
```

8. Test indexing:

```
CREATE INDEX idx_test_table_name ON test_table(name);
```

9. Show table structure:

```
SELECT column_name, data_type, character_maximum_length FROM INFORMATION_SCHEMA.COLUMNS WHERE table_name = 'test_table';
```

10. Test a transaction:

```
BEGIN;
INSERT INTO test_table (name) VALUES ('Transaction Test');
SAVEPOINT my_savepoint;
DELETE FROM test_table WHERE name = 'Transaction Test';
ROLLBACK TO my_savepoint;
COMMIT;
SELECT * FROM test_table WHERE name = 'Transaction Test';
```

11. Test user permissions (run as superuser):

```
CREATE USER test_user WITH PASSWORD 'password';
GRANT SELECT ON test_table TO test_user;
```

12. Test a simple function:

```
CREATE FUNCTION get_test_count() RETURNS INTEGER AS $$
BEGIN
    RETURN (SELECT COUNT(*) FROM test_table);
END;
$$ LANGUAGE plpgsql;

SELECT get_test_count();
```

13. Log out of the database:

```
\q
```

14. If you don't want to keep any of these configurations running consuming resources, you can destroy them:

```
terraform destroy
```
