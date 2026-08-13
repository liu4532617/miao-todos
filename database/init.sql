-- =============================================================
-- CRM 管理系统 - 数据库初始化脚本
-- 数据库类型：MySQL 8.0+
-- =============================================================

-- 创建数据库
CREATE DATABASE IF NOT EXISTS `dcf_db260729` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `dcf_db260729`;

-- =============================================================
-- 1. 系统管理模块
-- =============================================================

-- ----------------------------
-- 1.1 用户表
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username`    VARCHAR(64)     NOT NULL                COMMENT '用户名',
  `password`    VARCHAR(256)    NOT NULL                COMMENT '密码（加密后）',
  `nickname`    VARCHAR(64)     DEFAULT NULL            COMMENT '昵称',
  `email`       VARCHAR(128)    DEFAULT NULL            COMMENT '邮箱',
  `phone`       VARCHAR(20)     DEFAULT NULL            COMMENT '手机号',
  `avatar`      VARCHAR(256)    DEFAULT NULL            COMMENT '头像地址',
  `status`      TINYINT         NOT NULL DEFAULT 1      COMMENT '状态：0-禁用 1-启用',
  `create_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统用户表';

-- ----------------------------
-- 1.2 角色表
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `name`        VARCHAR(64)     NOT NULL                COMMENT '角色名称',
  `code`        VARCHAR(64)     NOT NULL                COMMENT '角色编码，如 admin、manager',
  `description` VARCHAR(256)    DEFAULT NULL            COMMENT '角色描述',
  `status`      TINYINT         NOT NULL DEFAULT 1      COMMENT '状态：0-禁用 1-启用',
  `sort`        INT             NOT NULL DEFAULT 0      COMMENT '排序号',
  `create_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统角色表';

-- ----------------------------
-- 1.3 用户-角色关联表
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
  `user_id` BIGINT UNSIGNED NOT NULL COMMENT '用户ID',
  `role_id` BIGINT UNSIGNED NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`),
  KEY `idx_role_id` (`role_id`),
  CONSTRAINT `fk_ur_user` FOREIGN KEY (`user_id`) REFERENCES `sys_user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ur_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户-角色关联表';

-- ----------------------------
-- 1.4 菜单资源表
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `parent_id`   BIGINT UNSIGNED DEFAULT NULL            COMMENT '父菜单ID（NULL 表示顶级菜单）',
  `name`        VARCHAR(64)     NOT NULL                COMMENT '菜单名称',
  `icon`        VARCHAR(64)     DEFAULT NULL            COMMENT '图标类名',
  `path`        VARCHAR(256)    DEFAULT NULL            COMMENT '路由路径',
  `component`   VARCHAR(256)    DEFAULT NULL            COMMENT '组件路径（相对 src/pages）',
  `permission`  VARCHAR(128)    DEFAULT NULL            COMMENT '权限标识，如 customer:list',
  `type`        TINYINT         NOT NULL DEFAULT 1      COMMENT '类型：1-目录 2-菜单 3-按钮',
  `sort`        INT             NOT NULL DEFAULT 0      COMMENT '排序号',
  `status`      TINYINT         NOT NULL DEFAULT 1      COMMENT '状态：0-隐藏 1-显示',
  `create_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_parent_id` (`parent_id`),
  KEY `idx_type` (`type`),
  CONSTRAINT `fk_menu_parent` FOREIGN KEY (`parent_id`) REFERENCES `sys_menu` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统菜单资源表';

-- ----------------------------
-- 1.5 权限表
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '权限ID',
  `name`        VARCHAR(64)     NOT NULL                COMMENT '权限名称',
  `code`        VARCHAR(128)    NOT NULL                COMMENT '权限标识，如 customer:create',
  `description` VARCHAR(256)    DEFAULT NULL            COMMENT '权限描述',
  `create_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统权限表';

-- ----------------------------
-- 1.6 角色-权限关联表
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_permission`;
CREATE TABLE `sys_role_permission` (
  `role_id`       BIGINT UNSIGNED NOT NULL COMMENT '角色ID',
  `permission_id` BIGINT UNSIGNED NOT NULL COMMENT '权限ID',
  PRIMARY KEY (`role_id`, `permission_id`),
  KEY `idx_permission_id` (`permission_id`),
  CONSTRAINT `fk_rp_role`       FOREIGN KEY (`role_id`)       REFERENCES `sys_role`       (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rp_permission` FOREIGN KEY (`permission_id`) REFERENCES `sys_permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色-权限关联表';

-- ----------------------------
-- 1.7 角色-菜单关联表
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
  `role_id` BIGINT UNSIGNED NOT NULL COMMENT '角色ID',
  `menu_id` BIGINT UNSIGNED NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`),
  KEY `idx_menu_id` (`menu_id`),
  CONSTRAINT `fk_rm_role` FOREIGN KEY (`role_id`) REFERENCES `sys_role` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rm_menu` FOREIGN KEY (`menu_id`) REFERENCES `sys_menu` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色-菜单关联表';

-- =============================================================
-- 2. 业务模块
-- =============================================================

-- ----------------------------
-- 2.1 客户表
-- ----------------------------
DROP TABLE IF EXISTS `dcf_customer`;
CREATE TABLE `dcf_customer` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '客户ID',
  `name`        VARCHAR(128)    NOT NULL                COMMENT '客户名称',
  `phone`       VARCHAR(20)     DEFAULT NULL            COMMENT '联系电话',
  `email`       VARCHAR(128)    DEFAULT NULL            COMMENT '邮箱',
  `company`     VARCHAR(256)    DEFAULT NULL            COMMENT '公司名称',
  `address`     VARCHAR(256)    DEFAULT NULL            COMMENT '地址',
  `source`      VARCHAR(32)     DEFAULT NULL            COMMENT '客户来源：recommend-推荐, advertise-广告, self-主动咨询',
  `level`       TINYINT         DEFAULT 1               COMMENT '客户等级：1-普通 2-重要 3-VIP',
  `status`      TINYINT         NOT NULL DEFAULT 1      COMMENT '状态：0-流失 1-跟进中 2-已成交',
  `owner_id`    BIGINT UNSIGNED DEFAULT NULL            COMMENT '负责人ID（关联 sys_user）',
  `remark`      TEXT            DEFAULT NULL            COMMENT '备注',
  `create_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_owner_id` (`owner_id`),
  KEY `idx_status` (`status`),
  KEY `idx_level` (`level`),
  KEY `idx_name` (`name`),
  CONSTRAINT `fk_customer_owner` FOREIGN KEY (`owner_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='客户表';

-- ----------------------------
-- 2.2 线索表
-- ----------------------------
DROP TABLE IF EXISTS `dcf_clue`;
CREATE TABLE `dcf_clue` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '线索ID',
  `name`        VARCHAR(128)    NOT NULL                COMMENT '线索名称/联系人',
  `phone`       VARCHAR(20)     DEFAULT NULL            COMMENT '联系电话',
  `source`      VARCHAR(32)     DEFAULT NULL            COMMENT '线索来源：web-官网, friend-朋友推荐, market-市场活动, other-其他',
  `status`      VARCHAR(32)     NOT NULL DEFAULT 'new'  COMMENT '状态：new-新建, following-跟进中, converted-已转化, closed-已关闭',
  `level`       TINYINT         DEFAULT 1               COMMENT '线索等级：1-低 2-中 3-高',
  `owner_id`    BIGINT UNSIGNED DEFAULT NULL            COMMENT '负责人ID',
  `customer_id` BIGINT UNSIGNED DEFAULT NULL            COMMENT '转化后的客户ID（已转化时填写）',
  `remark`      TEXT            DEFAULT NULL            COMMENT '备注',
  `create_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_owner_id` (`owner_id`),
  KEY `idx_status` (`status`),
  KEY `idx_source` (`source`),
  KEY `idx_customer_id` (`customer_id`),
  CONSTRAINT `fk_clue_owner`    FOREIGN KEY (`owner_id`)    REFERENCES `sys_user`    (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_clue_customer` FOREIGN KEY (`customer_id`) REFERENCES `dcf_customer` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='线索表';

-- ----------------------------
-- 2.3 任务表
-- ----------------------------
DROP TABLE IF EXISTS `dcf_task`;
CREATE TABLE `dcf_task` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '任务ID',
  `title`         VARCHAR(256)    NOT NULL                COMMENT '任务标题',
  `description`   TEXT            DEFAULT NULL            COMMENT '任务描述',
  `priority`      TINYINT         DEFAULT 2              COMMENT '优先级：1-低 2-中 3-高 4-紧急',
  `status`        VARCHAR(32)     NOT NULL DEFAULT 'todo' COMMENT '状态：todo-待办, doing-进行中, done-已完成, cancelled-已取消',
  `assignee_id`   BIGINT UNSIGNED DEFAULT NULL            COMMENT '负责人ID',
  `related_type`  VARCHAR(32)     DEFAULT NULL            COMMENT '关联类型：customer-客户, clue-线索, order-订单',
  `related_id`    BIGINT UNSIGNED DEFAULT NULL            COMMENT '关联业务ID',
  `deadline`      DATETIME        DEFAULT NULL            COMMENT '截止日期',
  `completed_at`  DATETIME        DEFAULT NULL            COMMENT '完成时间',
  `sort`          INT             NOT NULL DEFAULT 0      COMMENT '排序号',
  `create_time`   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_assignee_id` (`assignee_id`),
  KEY `idx_status` (`status`),
  KEY `idx_related` (`related_type`, `related_id`),
  KEY `idx_deadline` (`deadline`),
  CONSTRAINT `fk_task_assignee` FOREIGN KEY (`assignee_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='任务表';

-- ----------------------------
-- 2.4 产品表
-- ----------------------------
DROP TABLE IF EXISTS `dcf_product`;
CREATE TABLE `dcf_product` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '产品ID',
  `name`          VARCHAR(256)    NOT NULL                COMMENT '产品名称',
  `category`      VARCHAR(64)     DEFAULT NULL            COMMENT '产品分类：software-软件, hardware-硬件, service-服务',
  `description`   TEXT            DEFAULT NULL            COMMENT '产品描述',
  `price`         DECIMAL(12, 2)  NOT NULL DEFAULT 0.00   COMMENT '单价（元）',
  `unit`          VARCHAR(16)     DEFAULT '个'            COMMENT '单位',
  `stock`         INT             NOT NULL DEFAULT 0      COMMENT '库存数量',
  `status`        TINYINT         NOT NULL DEFAULT 1      COMMENT '状态：0-下架 1-上架',
  `image`         VARCHAR(256)    DEFAULT NULL            COMMENT '产品图片',
  `create_time`   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`   DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`),
  KEY `idx_status` (`status`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='产品表';

-- ----------------------------
-- 2.5 订单表
-- ----------------------------
DROP TABLE IF EXISTS `dcf_order`;
CREATE TABLE `dcf_order` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '订单ID',
  `order_no`        VARCHAR(64)     NOT NULL                COMMENT '订单编号',
  `customer_id`     BIGINT UNSIGNED DEFAULT NULL            COMMENT '客户ID',
  `total_amount`    DECIMAL(12, 2)  NOT NULL DEFAULT 0.00   COMMENT '订单总金额',
  `paid_amount`     DECIMAL(12, 2)  DEFAULT NULL            COMMENT '已付款金额',
  `status`          VARCHAR(32)     NOT NULL DEFAULT 'pending' COMMENT '状态：pending-待付款, paid-已付款, completed-已完成, cancelled-已取消, refunded-已退款',
  `payment_method`  VARCHAR(32)     DEFAULT NULL            COMMENT '付款方式：wechat-微信, alipay-支付宝, bank-银行转账, cash-现金',
  `paid_at`         DATETIME        DEFAULT NULL            COMMENT '付款时间',
  `remark`          TEXT            DEFAULT NULL            COMMENT '备注',
  `owner_id`        BIGINT UNSIGNED DEFAULT NULL            COMMENT '负责人ID',
  `create_time`     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time`     DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_no` (`order_no`),
  KEY `idx_customer_id` (`customer_id`),
  KEY `idx_owner_id` (`owner_id`),
  KEY `idx_status` (`status`),
  KEY `idx_create_time` (`create_time`),
  CONSTRAINT `fk_order_customer` FOREIGN KEY (`customer_id`) REFERENCES `dcf_customer` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_order_owner`    FOREIGN KEY (`owner_id`)    REFERENCES `sys_user`    (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单表';

-- ----------------------------
-- 2.6 订单-产品明细表
-- ----------------------------
DROP TABLE IF EXISTS `dcf_order_item`;
CREATE TABLE `dcf_order_item` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '明细ID',
  `order_id`    BIGINT UNSIGNED NOT NULL                COMMENT '订单ID',
  `product_id`  BIGINT UNSIGNED DEFAULT NULL            COMMENT '产品ID',
  `product_name` VARCHAR(256)   NOT NULL                COMMENT '产品名称（下单时快照）',
  `price`       DECIMAL(12, 2)  NOT NULL                COMMENT '单价（元）',
  `quantity`    INT             NOT NULL DEFAULT 1      COMMENT '数量',
  `subtotal`    DECIMAL(12, 2)  NOT NULL                COMMENT '小计金额',
  `create_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_order_id` (`order_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `fk_oi_order`   FOREIGN KEY (`order_id`)   REFERENCES `dcf_order`   (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_oi_product` FOREIGN KEY (`product_id`) REFERENCES `dcf_product` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='订单明细表';

-- ----------------------------
-- 2.7 知识库文章表
-- ----------------------------
DROP TABLE IF EXISTS `dcf_knowledge`;
CREATE TABLE `dcf_knowledge` (
  `id`          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '文章ID',
  `title`       VARCHAR(256)    NOT NULL                COMMENT '文章标题',
  `content`     LONGTEXT        DEFAULT NULL            COMMENT '文章内容（支持 HTML/Markdown）',
  `category`    VARCHAR(64)     DEFAULT NULL            COMMENT '分类：guide-使用指南, faq-常见问题, best-practice-最佳实践',
  `author_id`   BIGINT UNSIGNED DEFAULT NULL            COMMENT '作者ID',
  `tags`        VARCHAR(256)    DEFAULT NULL            COMMENT '标签，多个用逗号分隔',
  `views`       INT             NOT NULL DEFAULT 0      COMMENT '浏览次数',
  `status`      TINYINT         NOT NULL DEFAULT 1      COMMENT '状态：0-草稿 1-已发布',
  `create_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`),
  KEY `idx_author_id` (`author_id`),
  KEY `idx_status` (`status`),
  FULLTEXT KEY `ft_title_content` (`title`, `content`),
  CONSTRAINT `fk_knowledge_author` FOREIGN KEY (`author_id`) REFERENCES `sys_user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='知识库文章表';

-- =============================================================
-- 3. 初始数据
-- =============================================================

-- ----------------------------
-- 默认管理员账号（密码：admin123）
-- BCrypt 加密后的密码
-- ----------------------------
INSERT INTO `sys_user` (`id`, `username`, `password`, `nickname`, `email`, `status`) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iAt6Z5EH', '管理员', 'admin@crm.com', 1);

-- ----------------------------
-- 默认角色
-- ----------------------------
INSERT INTO `sys_role` (`id`, `name`, `code`, `description`, `status`) VALUES
(1, '超级管理员', 'super_admin', '拥有系统全部权限', 1),
(2, '销售经理',   'sales_manager', '管理销售团队和客户', 1),
(3, '销售员',     'salesman',      '普通销售人员', 1);

-- ----------------------------
-- 分配管理员角色
-- ----------------------------
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (1, 1);

-- ----------------------------
-- 默认菜单数据
-- ----------------------------
INSERT INTO `sys_menu` (`id`, `parent_id`, `name`, `icon`, `path`, `component`, `type`, `sort`, `status`) VALUES
-- 一级菜单
(1,  NULL, '工作台',     'Odometer',  '/',         'dashboard/index',   1, 1, 1),
(2,  NULL, '业务管理',   'Briefcase', NULL,        NULL,                1, 2, 1),
(3,  NULL, '系统管理',   'Setting',   NULL,        NULL,                1, 3, 1),

-- 业务管理子菜单
(4,  2,    '客户管理',   NULL, '/customer',     'customer/index',     2, 1, 1),
(5,  2,    '线索管理',   NULL, '/clue',         'clue/index',         2, 2, 1),
(6,  2,    '任务管理',   NULL, '/task-list',    'tasks/index',        2, 3, 1),
(7,  2,    '知识库',     NULL, '/knowledge',    'knowledge/index',    2, 4, 1),
(8,  2,    '订单管理',   NULL, '/order',        'order/index',        2, 5, 1),
(9,  2,    '产品管理',   NULL, '/product',      'product/index',      2, 6, 1),

-- 系统管理子菜单
(10, 3,    '用户管理',   NULL, '/system/user',       'system/user/index',      2, 1, 1),
(11, 3,    '角色管理',   NULL, '/system/role',       'system/role/index',      2, 2, 1),
(12, 3,    '权限管理',   NULL, '/system/permission', 'system/permission/index', 2, 3, 1),
(13, 3,    '菜单资源',   NULL, '/system/menu',       'system/menu/index',      2, 4, 1);

-- ----------------------------
-- 角色-菜单关联（决定各角色可见菜单）
-- ----------------------------
-- 超级管理员：全部菜单 (1-13)
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10), (1, 11), (1, 12), (1, 13);

-- 销售经理：工作台 + 业务管理（客户/线索/任务/知识库/订单/产品）
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(2, 1), (2, 2), (2, 4), (2, 5), (2, 6), (2, 7), (2, 8), (2, 9);

-- 销售员：工作台 + 客户/线索/任务
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES
(3, 1), (3, 2), (3, 4), (3, 5), (3, 6);


