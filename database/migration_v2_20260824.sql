-- ============================================================
-- 灶台招工 改版 v2 数据库迁移脚本
-- 方案:三步闭环(发岗/发求职卡 → 直聊/申请联系方式 → 约试工)
-- 日期:2026-08-24
-- 说明:新增 2 表 + 修改 3 表,弃用 uni_application/uni_interview(保留数据)
-- ============================================================

-- ------------------------------------------------------------
-- 1. 新增 uni_trial 试工单表(替代面试流程)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `uni_trial` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `chat_id` bigint DEFAULT NULL COMMENT '来源会话ID(uni_chat.id)',
  `job_id` bigint DEFAULT NULL COMMENT '岗位ID(uni_job.id)',
  `company_id` bigint DEFAULT NULL COMMENT '公司ID(uni_company.id,冗余便于统计)',
  `company_user_id` bigint DEFAULT NULL COMMENT '招聘方用户ID(uni_user.id)',
  `user_id` bigint NOT NULL COMMENT '求职者ID(uni_user.id)',
  `trial_time` datetime DEFAULT NULL COMMENT '试工时间',
  `location` varchar(200) DEFAULT NULL COMMENT '试工地点',
  `contact_phone` varchar(20) DEFAULT NULL COMMENT '试工联系电话',
  `status` varchar(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态: PENDING待确认 CONFIRMED已确认 ARRIVED已到店 COMPLETED试工完成 HIRED已录用 REJECTED不合适 CANCELLED取消',
  `result_remark` varchar(500) DEFAULT NULL COMMENT '录用/不合适的备注',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_job_id` (`job_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_status` (`status`),
  KEY `idx_chat_id` (`chat_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='试工单表(替代面试)';

-- ------------------------------------------------------------
-- 2. 新增 uni_contact_apply 联系方式申请表(私密档核心)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `uni_contact_apply` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
  `chat_id` bigint DEFAULT NULL COMMENT '会话ID(uni_chat.id)',
  `applicant_id` bigint NOT NULL COMMENT '申请人ID(uni_user.id)',
  `target_id` bigint NOT NULL COMMENT '被申请人ID(uni_user.id)',
  `apply_type` varchar(10) NOT NULL COMMENT '类型: PHONE电话 WECHAT微信',
  `status` varchar(10) NOT NULL DEFAULT 'PENDING' COMMENT '状态: PENDING待处理 AGREED已同意 REJECTED已拒绝',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_chat_id` (`chat_id`),
  KEY `idx_target_id` (`target_id`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='联系方式申请表';

-- ------------------------------------------------------------
-- 3. 修改 uni_job 岗位表
-- ------------------------------------------------------------
ALTER TABLE `uni_job`
  MODIFY COLUMN `status` tinyint NOT NULL DEFAULT '1' COMMENT '状态: 1-招聘中 0-已下架 2-已招到',
  ADD COLUMN `hired_at` datetime DEFAULT NULL COMMENT '招到时间(统计今日招到)' AFTER `status`,
  ADD COLUMN `contact_visibility` varchar(20) NOT NULL DEFAULT 'CHAT_UNLOCK' COMMENT '招聘方联系方式可见性: PUBLIC公开 CHAT_UNLOCK聊后解锁 PRIVATE私密' AFTER `hired_at`,
  ADD COLUMN `district` varchar(50) DEFAULT NULL COMMENT '区域(城东/老城区等,用于附近统计)' AFTER `location`,
  ADD KEY `idx_hired_at` (`hired_at`);

-- ------------------------------------------------------------
-- 4. 修改 uni_user 用户表
-- ------------------------------------------------------------
ALTER TABLE `uni_user`
  ADD COLUMN `contact_visibility` varchar(20) NOT NULL DEFAULT 'CHAT_UNLOCK' COMMENT '默认联系方式可见性: PUBLIC公开 CHAT_UNLOCK聊后解锁 PRIVATE私密' AFTER `company_auth`;
-- 注: role 字段已废弃(公司认证机制替代),保留不删,避免历史数据异常

-- ------------------------------------------------------------
-- 5. 修改 uni_resume 简历表 → 求职卡
-- ------------------------------------------------------------
ALTER TABLE `uni_resume`
  ADD COLUMN `available_time` varchar(50) DEFAULT NULL COMMENT '可到岗时间(明天/3天内/随时)' AFTER `status`,
  ADD COLUMN `need_accommodation` tinyint NOT NULL DEFAULT '0' COMMENT '是否需包吃住: 0-否 1-是' AFTER `available_time`,
  ADD COLUMN `seek_status` tinyint NOT NULL DEFAULT '1' COMMENT '求职卡状态: 1-找工作中 0-私密 2-已找到' AFTER `need_accommodation`,
  ADD COLUMN `contact_visibility` varchar(20) NOT NULL DEFAULT 'CHAT_UNLOCK' COMMENT '求职者联系方式可见性: PUBLIC公开 CHAT_UNLOCK聊后解锁 PRIVATE私密' AFTER `seek_status`;

-- ------------------------------------------------------------
-- 6. uni_favorite 支持收藏求职卡(枚举扩展,不落 DDL)
--    business_type 新增枚举值: SEEK_CARD-求职卡(收藏时指向 uni_resume.id)
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- 7. uni_user 加 openid(微信小程序登录)
-- ------------------------------------------------------------
ALTER TABLE `uni_user`
  ADD COLUMN `openid` varchar(64) DEFAULT NULL COMMENT '微信小程序openid' AFTER `username`,
  ADD UNIQUE KEY `uk_openid` (`openid`);
