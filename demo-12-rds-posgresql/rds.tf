resource "aws_db_subnet_group" "postgresql-subnet" {
  name        = "postgresql-subnet"
  description = "RDS subnet group"
  subnet_ids  = [aws_subnet.main-private-1.id, aws_subnet.main-private-2.id]
}

resource "aws_db_parameter_group" "postgresql-parameters" {
  name        = "postgresql-parameters"
  family      = "postgres14"
  description = "PostgreSQL parameter group"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "postgresql" {
  allocated_storage       = 100 # 100 GB of storage, gives us more IOPS than a lower number
  engine                  = "postgres"
  engine_version          = "14"
  instance_class          = "db.t3.micro" # use micro if you want to use the free tier
  identifier              = "postgresql"
  db_name                 = "topinion"
  username                = "root"           # username
  password                = var.RDS_PASSWORD # password
  db_subnet_group_name    = aws_db_subnet_group.postgresql-subnet.name
  parameter_group_name    = aws_db_parameter_group.postgresql-parameters.name
  multi_az                = "false" # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids  = [aws_security_group.allow-postgresql.id]
  storage_type            = "gp2"
  backup_retention_period = 30                                          # how long you’re going to keep your backups
  availability_zone       = aws_subnet.main-private-1.availability_zone # prefered AZ
  skip_final_snapshot     = true                                        # skip final snapshot when doing terraform destroy
  tags = {
    Name = "postgresql-instance"
  }
}

