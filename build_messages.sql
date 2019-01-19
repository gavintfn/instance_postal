
CREATE DATABASE `postal_msg-server-1`;

SET NAMES 'utf8';

USE `postal_msg-server-1`;

DROP TABLE IF EXISTS clicks;
CREATE TABLE clicks (
  id INT(11) NOT NULL AUTO_INCREMENT,
  message_id INT(11) DEFAULT NULL,
  link_id INT(11) DEFAULT NULL,
  ip_address VARCHAR(255) DEFAULT NULL,
  country VARCHAR(255) DEFAULT NULL,
  city VARCHAR(255) DEFAULT NULL,
  user_agent VARCHAR(255) DEFAULT NULL,
  timestamp DECIMAL(18, 6) DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX on_link_id (link_id),
  INDEX on_message_id (message_id)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS deliveries;
CREATE TABLE deliveries (
  id INT(11) NOT NULL AUTO_INCREMENT,
  message_id INT(11) DEFAULT NULL,
  status VARCHAR(255) DEFAULT NULL,
  code INT(11) DEFAULT NULL,
  output VARCHAR(512) DEFAULT NULL,
  details VARCHAR(512) DEFAULT NULL,
  sent_with_ssl TINYINT(1) DEFAULT 0,
  log_id VARCHAR(100) DEFAULT NULL,
  timestamp DECIMAL(18, 6) DEFAULT NULL,
  time DECIMAL(8, 2) DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX on_message_id (message_id)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS links;
CREATE TABLE links (
  id INT(11) NOT NULL AUTO_INCREMENT,
  message_id INT(11) DEFAULT NULL,
  token VARCHAR(255) DEFAULT NULL,
  hash VARCHAR(255) DEFAULT NULL,
  url VARCHAR(255) DEFAULT NULL,
  timestamp DECIMAL(18, 6) DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX on_message_id (message_id),
  INDEX on_token (token(8))
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS live_stats;
CREATE TABLE live_stats (
  type VARCHAR(20) NOT NULL,
  minute INT(11) NOT NULL,
  count INT(11) DEFAULT NULL,
  timestamp DECIMAL(18, 6) DEFAULT NULL,
  PRIMARY KEY (minute, type(8))
)
ENGINE = INNODB
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS loads;
CREATE TABLE loads (
  id INT(11) NOT NULL AUTO_INCREMENT,
  message_id INT(11) DEFAULT NULL,
  ip_address VARCHAR(255) DEFAULT NULL,
  country VARCHAR(255) DEFAULT NULL,
  city VARCHAR(255) DEFAULT NULL,
  user_agent VARCHAR(255) DEFAULT NULL,
  timestamp DECIMAL(18, 6) DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX on_message_id (message_id)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
  id INT(11) NOT NULL AUTO_INCREMENT,
  token VARCHAR(255) DEFAULT NULL,
  scope VARCHAR(10) DEFAULT NULL,
  rcpt_to VARCHAR(255) DEFAULT NULL,
  mail_from VARCHAR(255) DEFAULT NULL,
  subject VARCHAR(255) DEFAULT NULL,
  message_id VARCHAR(255) DEFAULT NULL,
  timestamp DECIMAL(18, 6) DEFAULT NULL,
  route_id INT(11) DEFAULT NULL,
  domain_id INT(11) DEFAULT NULL,
  credential_id INT(11) DEFAULT NULL,
  status VARCHAR(255) DEFAULT NULL,
  held TINYINT(1) DEFAULT 0,
  size VARCHAR(255) DEFAULT NULL,
  last_delivery_attempt DECIMAL(18, 6) DEFAULT NULL,
  raw_table VARCHAR(255) DEFAULT NULL,
  raw_body_id INT(11) DEFAULT NULL,
  raw_headers_id INT(11) DEFAULT NULL,
  inspected TINYINT(1) DEFAULT 0,
  spam TINYINT(1) DEFAULT 0,
  spam_score DECIMAL(8, 2) DEFAULT 0.00,
  threat TINYINT(1) DEFAULT 0,
  threat_details VARCHAR(255) DEFAULT NULL,
  bounce TINYINT(1) DEFAULT 0,
  bounce_for_id INT(11) DEFAULT 0,
  tag VARCHAR(255) DEFAULT NULL,
  loaded DECIMAL(18, 6) DEFAULT NULL,
  clicked DECIMAL(18, 6) DEFAULT NULL,
  received_with_ssl TINYINT(1) DEFAULT NULL,
  hold_expiry DECIMAL(18, 6) DEFAULT NULL,
  tracked_links INT(11) DEFAULT 0,
  tracked_images INT(11) DEFAULT 0,
  parsed TINYINT(4) DEFAULT 0,
  endpoint_id INT(11) DEFAULT NULL,
  endpoint_type VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX on_bounce_for_id (bounce_for_id),
  INDEX on_held (held),
  INDEX on_mail_from (mail_from(12), timestamp),
  INDEX on_message_id (message_id(8)),
  INDEX on_raw_table (raw_table(14)),
  INDEX on_rcpt_to (rcpt_to(12), timestamp),
  INDEX on_scope_and_spam (scope(1), spam, timestamp),
  INDEX on_scope_and_status (scope(1), spam, status(6), timestamp),
  INDEX on_scope_and_tag (scope(1), spam, tag(8), timestamp),
  INDEX on_scope_and_thr_status (scope(1), threat, status(6), timestamp),
  INDEX on_scope_and_threat (scope(1), threat, timestamp),
  INDEX on_status (status(8)),
  INDEX on_token (token(6))
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS migrations;
CREATE TABLE migrations (
  version INT(11) NOT NULL,
  PRIMARY KEY (version)
)
ENGINE = INNODB
AVG_ROW_LENGTH = 910
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS raw_message_sizes;
CREATE TABLE raw_message_sizes (
  id INT(11) NOT NULL AUTO_INCREMENT,
  table_name VARCHAR(255) DEFAULT NULL,
  size BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX on_table_name (table_name(14))
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS spam_checks;
CREATE TABLE spam_checks (
  id INT(11) NOT NULL AUTO_INCREMENT,
  message_id INT(11) DEFAULT NULL,
  score DECIMAL(8, 2) DEFAULT NULL,
  code VARCHAR(255) DEFAULT NULL,
  description VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX on_code (code(8)),
  INDEX on_message_id (message_id)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS stats_daily;
CREATE TABLE stats_daily (
  id INT(11) NOT NULL AUTO_INCREMENT,
  time INT(11) DEFAULT NULL,
  incoming BIGINT(20) DEFAULT NULL,
  outgoing BIGINT(20) DEFAULT NULL,
  spam BIGINT(20) DEFAULT NULL,
  bounces BIGINT(20) DEFAULT NULL,
  held BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX on_time (time)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS stats_hourly;
CREATE TABLE stats_hourly (
  id INT(11) NOT NULL AUTO_INCREMENT,
  time INT(11) DEFAULT NULL,
  incoming BIGINT(20) DEFAULT NULL,
  outgoing BIGINT(20) DEFAULT NULL,
  spam BIGINT(20) DEFAULT NULL,
  bounces BIGINT(20) DEFAULT NULL,
  held BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX on_time (time)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS stats_monthly;
CREATE TABLE stats_monthly (
  id INT(11) NOT NULL AUTO_INCREMENT,
  time INT(11) DEFAULT NULL,
  incoming BIGINT(20) DEFAULT NULL,
  outgoing BIGINT(20) DEFAULT NULL,
  spam BIGINT(20) DEFAULT NULL,
  bounces BIGINT(20) DEFAULT NULL,
  held BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX on_time (time)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS stats_yearly;
CREATE TABLE stats_yearly (
  id INT(11) NOT NULL AUTO_INCREMENT,
  time INT(11) DEFAULT NULL,
  incoming BIGINT(20) DEFAULT NULL,
  outgoing BIGINT(20) DEFAULT NULL,
  spam BIGINT(20) DEFAULT NULL,
  bounces BIGINT(20) DEFAULT NULL,
  held BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE INDEX on_time (time)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS suppressions;
CREATE TABLE suppressions (
  id INT(11) NOT NULL AUTO_INCREMENT,
  type VARCHAR(255) DEFAULT NULL,
  address VARCHAR(255) DEFAULT NULL,
  reason VARCHAR(255) DEFAULT NULL,
  timestamp DECIMAL(18, 6) DEFAULT NULL,
  keep_until DECIMAL(18, 6) DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX on_address (address(6)),
  INDEX on_keep_until (keep_until)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;

DROP TABLE IF EXISTS webhook_requests;
CREATE TABLE webhook_requests (
  id INT(11) NOT NULL AUTO_INCREMENT,
  uuid VARCHAR(255) DEFAULT NULL,
  event VARCHAR(255) DEFAULT NULL,
  attempt INT(11) DEFAULT NULL,
  timestamp DECIMAL(18, 6) DEFAULT NULL,
  status_code INT(1) DEFAULT NULL,
  body TEXT DEFAULT NULL,
  payload TEXT DEFAULT NULL,
  will_retry TINYINT(4) DEFAULT NULL,
  url VARCHAR(255) DEFAULT NULL,
  webhook_id INT(11) DEFAULT NULL,
  PRIMARY KEY (id),
  INDEX on_event (event(8)),
  INDEX on_timestamp (timestamp),
  INDEX on_uuid (uuid(8)),
  INDEX on_webhook_id (webhook_id)
)
ENGINE = INNODB
AUTO_INCREMENT = 1
CHARACTER SET utf8
COLLATE utf8_general_ci;


INSERT INTO migrations VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10),
(11),
(12),
(13),
(14),
(15),
(16),
(17),
(18);
