

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for customers
-- ----------------------------
DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(0) NULL DEFAULT NULL,
  `updatedAt` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `balance` float NOT NULL DEFAULT 0,
  `bonus_balance` float NOT NULL DEFAULT 0,
  `bonus_per` int NULL DEFAULT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `gender` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique`(`id`, `email`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for deposits
-- ----------------------------
DROP TABLE IF EXISTS `deposits`;
CREATE TABLE `deposits`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(0) NULL DEFAULT NULL,
  `updatedAt` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `customer_id` int NULL DEFAULT NULL,
  `amount` float NULL DEFAULT NULL,
  `bonus_amount` float NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique`(`id`) USING BTREE,
  INDEX `other`(`createdAt`, `customer_id`, `amount`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Table structure for withdraws
-- ----------------------------
DROP TABLE IF EXISTS `withdraws`;
CREATE TABLE `withdraws`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `createdAt` datetime(0) NULL DEFAULT NULL,
  `updatedAt` datetime(0) NULL DEFAULT CURRENT_TIMESTAMP(0) ON UPDATE CURRENT_TIMESTAMP(0),
  `customer_id` int NULL DEFAULT NULL,
  `amount` float NULL DEFAULT NULL,
  `rejected` int NULL DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique`(`id`) USING BTREE,
  INDEX `other`(`customer_id`, `amount`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Triggers structure for table deposits
-- ----------------------------
DROP TRIGGER IF EXISTS `balance_update`;
delimiter ;;
CREATE TRIGGER `balance_update` AFTER INSERT ON `deposits` FOR EACH ROW BEGIN
	SET @newBalance := (SELECT balance FROM customers WHERE id = new.customer_id) + new.amount;
	SET @newBonusBalance := (SELECT bonus_balance FROM customers WHERE id = new.customer_id) + new.bonus_amount;
	UPDATE customers SET balance = @newBalance, bonus_balance = @newBonusBalance WHERE id = new.customer_id;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table withdraws
-- ----------------------------
DROP TRIGGER IF EXISTS `balance_updater`;
delimiter ;;
CREATE TRIGGER `balance_updater` AFTER INSERT ON `withdraws` FOR EACH ROW BEGIN
	SET @newBalance := (SELECT balance FROM customers WHERE id = new.customer_id) - new.amount;
	IF(new.rejected != 1 AND @newBalance >= 0) THEN
		UPDATE customers SET balance = @newBalance WHERE id = new.customer_id;
	END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
