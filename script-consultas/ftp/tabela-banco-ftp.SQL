CREATE TABLE ftpd (
User varchar(16) NOT NULL default '',
status enum('0','1') NOT NULL default '0',
Password varchar(64) NOT NULL default '',
Uid varchar(11) NOT NULL default '-1',
Gid varchar(11) NOT NULL default '-1',
Dir varchar(128) NOT NULL default '',
ULBandwidth smallint(5) NOT NULL default '0',
DLBandwidth smallint(5) NOT NULL default '0',
comment tinytext NOT NULL,
ipaccess varchar(15) NOT NULL default '*',
QuotaSize smallint(5) NOT NULL default '0',
QuotaFiles int(11) NOT NULL default 0,
PRIMARY KEY (User),
UNIQUE KEY User (User)
);
