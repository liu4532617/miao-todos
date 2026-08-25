# miao-todos 数据库表结构全览

> 数据库: dcf_db260729 | 共 24 张表

## 目录

- **小程序业务(uni_)** (10): uni_application, uni_chat, uni_chat_message, uni_dynamic, uni_favorite, uni_interview, uni_job, uni_product, uni_resume, uni_user
- **后台业务(crm_)** (7): crm_clue, crm_customer, crm_knowledge, crm_order, crm_order_item, crm_product, crm_task
- **系统权限(sys_)** (7): sys_menu, sys_permission, sys_role, sys_role_menu, sys_role_permission, sys_user, sys_user_role


---

## crm_clue
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 线索ID |
| name | varchar(128) | NO |  | NULL | 线索名称/联系人 |
| phone | varchar(20) | YES |  | NULL | 联系电话 |
| source | varchar(32) | YES | MUL | NULL | 线索来源：web-官网, friend-朋友推荐, market-市场活动, other-其他 |
| status | varchar(32) | NO | MUL | new | 状态：new-新建, following-跟进中, converted-已转化, closed-已关闭 |
| level | tinyint | YES |  | 1 | 线索等级：1-低 2-中 3-高 |
| owner_id | bigint unsigned | YES | MUL | NULL | 负责人ID |
| customer_id | bigint unsigned | YES | MUL | NULL | 转化后的客户ID（已转化时填写） |
| remark | text | YES |  | NULL | 备注 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: customer_id(idx_customer_id), owner_id(idx_owner_id), source(idx_source), status(idx_status), id(PRIMARY)

---

## crm_customer
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 客户ID |
| name | varchar(128) | NO | MUL | NULL | 客户名称 |
| phone | varchar(20) | YES |  | NULL | 联系电话 |
| email | varchar(128) | YES |  | NULL | 邮箱 |
| company | varchar(256) | YES |  | NULL | 公司名称 |
| address | varchar(256) | YES |  | NULL | 地址 |
| source | varchar(32) | YES |  | NULL | 客户来源：recommend-推荐, advertise-广告, self-主动咨询 |
| level | tinyint | YES | MUL | 1 | 客户等级：1-普通 2-重要 3-VIP |
| status | tinyint | NO | MUL | 1 | 状态：0-流失 1-跟进中 2-已成交 |
| owner_id | bigint unsigned | YES | MUL | NULL | 负责人ID（关联 sys_user） |
| remark | text | YES |  | NULL | 备注 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: level(idx_level), name(idx_name), owner_id(idx_owner_id), status(idx_status), id(PRIMARY)

---

## crm_knowledge
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 文章ID |
| title | varchar(256) | NO | MUL | NULL | 文章标题 |
| content | longtext | YES |  | NULL | 文章内容（支持 HTML/Markdown） |
| category | varchar(64) | YES | MUL | NULL | 分类：guide-使用指南, faq-常见问题, best-practice-最佳实践 |
| author_id | bigint unsigned | YES | MUL | NULL | 作者ID |
| tags | varchar(256) | YES |  | NULL | 标签，多个用逗号分隔 |
| views | int | NO |  | 0 | 浏览次数 |
| status | tinyint | NO | MUL | 1 | 状态：0-草稿 1-已发布 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: title(ft_title_content), content(ft_title_content), author_id(idx_author_id), category(idx_category), status(idx_status), id(PRIMARY)

---

## crm_order
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 订单ID |
| order_no | varchar(64) | NO | UNI | NULL | 订单编号 |
| customer_id | bigint unsigned | YES | MUL | NULL | 客户ID |
| total_amount | decimal(12,2) | NO |  | 0.00 | 订单总金额 |
| paid_amount | decimal(12,2) | YES |  | NULL | 已付款金额 |
| status | varchar(32) | NO | MUL | pending | 状态：pending-待付款, paid-已付款, completed-已完成, cancelled-已取消, refunded-已退款 |
| payment_method | varchar(32) | YES |  | NULL | 付款方式：wechat-微信, alipay-支付宝, bank-银行转账, cash-现金 |
| paid_at | datetime | YES |  | NULL | 付款时间 |
| remark | text | YES |  | NULL | 备注 |
| owner_id | bigint unsigned | YES | MUL | NULL | 负责人ID |
| create_time | datetime | NO | MUL | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: create_time(idx_create_time), customer_id(idx_customer_id), owner_id(idx_owner_id), status(idx_status), id(PRIMARY), order_no(uk_order_no)

---

## crm_order_item
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 明细ID |
| order_id | bigint unsigned | NO | MUL | NULL | 订单ID |
| product_id | bigint unsigned | YES | MUL | NULL | 产品ID |
| product_name | varchar(256) | NO |  | NULL | 产品名称（下单时快照） |
| price | decimal(12,2) | NO |  | NULL | 单价（元） |
| quantity | int | NO |  | 1 | 数量 |
| subtotal | decimal(12,2) | NO |  | NULL | 小计金额 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |

**索引**: order_id(idx_order_id), product_id(idx_product_id), id(PRIMARY)

---

## crm_product
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 产品ID |
| name | varchar(256) | NO | MUL | NULL | 产品名称 |
| category | varchar(64) | YES | MUL | NULL | 产品分类：software-软件, hardware-硬件, service-服务 |
| description | text | YES |  | NULL | 产品描述 |
| price | decimal(12,2) | NO |  | 0.00 | 单价（元） |
| unit | varchar(16) | YES |  | 个 | 单位 |
| stock | int | NO |  | 0 | 库存数量 |
| status | tinyint | NO | MUL | 1 | 状态：0-下架 1-上架 |
| image | varchar(256) | YES |  | NULL | 产品图片 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: category(idx_category), name(idx_name), status(idx_status), id(PRIMARY)

---

## crm_task
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 任务ID |
| title | varchar(256) | NO |  | NULL | 任务标题 |
| description | text | YES |  | NULL | 任务描述 |
| priority | tinyint | YES |  | 2 | 优先级：1-低 2-中 3-高 4-紧急 |
| status | varchar(32) | NO | MUL | todo | 状态：todo-待办, doing-进行中, done-已完成, cancelled-已取消 |
| assignee_id | bigint unsigned | YES | MUL | NULL | 负责人ID |
| related_type | varchar(32) | YES | MUL | NULL | 关联类型：customer-客户, clue-线索, order-订单 |
| related_id | bigint unsigned | YES |  | NULL | 关联业务ID |
| deadline | datetime | YES | MUL | NULL | 截止日期 |
| completed_at | datetime | YES |  | NULL | 完成时间 |
| sort | int | NO |  | 0 | 排序号 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: assignee_id(idx_assignee_id), deadline(idx_deadline), related_type(idx_related), related_id(idx_related), status(idx_status), id(PRIMARY)

---

## sys_menu
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 菜单ID |
| parent_id | bigint unsigned | YES | MUL | NULL | 父菜单ID（NULL 表示顶级菜单） |
| name | varchar(64) | NO |  | NULL | 菜单名称 |
| icon | varchar(64) | YES |  | NULL | 图标类名 |
| path | varchar(256) | YES |  | NULL | 路由路径 |
| component | varchar(256) | YES |  | NULL | 组件路径（相对 src/pages） |
| permission | varchar(128) | YES |  | NULL | 权限标识，如 customer:list |
| type | tinyint | NO | MUL | 1 | 类型：1-目录 2-菜单 3-按钮 |
| sort | int | NO |  | 0 | 排序号 |
| status | tinyint | NO |  | 1 | 状态：0-隐藏 1-显示 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: parent_id(idx_parent_id), type(idx_type), id(PRIMARY)

---

## sys_permission
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 权限ID |
| name | varchar(64) | NO |  | NULL | 权限名称 |
| code | varchar(128) | NO | UNI | NULL | 权限标识，如 customer:create |
| description | varchar(256) | YES |  | NULL | 权限描述 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: id(PRIMARY), code(uk_code)

---

## sys_role
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 角色ID |
| name | varchar(64) | NO |  | NULL | 角色名称 |
| code | varchar(64) | NO | UNI | NULL | 角色编码，如 admin、manager |
| description | varchar(256) | YES |  | NULL | 角色描述 |
| status | tinyint | NO | MUL | 1 | 状态：0-禁用 1-启用 |
| sort | int | NO |  | 0 | 排序号 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: status(idx_status), id(PRIMARY), code(uk_code)

---

## sys_role_menu
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| role_id | bigint unsigned | NO | PRI | NULL | 角色ID |
| menu_id | bigint unsigned | NO | PRI | NULL | 菜单ID |

**索引**: menu_id(idx_menu_id), role_id(PRIMARY), menu_id(PRIMARY)

---

## sys_role_permission
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| role_id | bigint unsigned | NO | PRI | NULL | 角色ID |
| permission_id | bigint unsigned | NO | PRI | NULL | 权限ID |

**索引**: permission_id(idx_permission_id), role_id(PRIMARY), permission_id(PRIMARY)

---

## sys_user
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint unsigned | NO | PRI | NULL | 用户ID |
| username | varchar(64) | NO | UNI | NULL | 用户名 |
| password | varchar(256) | NO |  | NULL | 密码（加密后） |
| nickname | varchar(64) | YES |  | NULL | 昵称 |
| email | varchar(128) | YES |  | NULL | 邮箱 |
| phone | varchar(20) | YES |  | NULL | 手机号 |
| avatar | varchar(256) | YES |  | NULL | 头像地址 |
| status | tinyint | NO | MUL | 1 | 状态：0-禁用 1-启用 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: status(idx_status), id(PRIMARY), username(uk_username)

---

## sys_user_role
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| user_id | bigint unsigned | NO | PRI | NULL | 用户ID |
| role_id | bigint unsigned | NO | PRI | NULL | 角色ID |

**索引**: role_id(idx_role_id), user_id(PRIMARY), role_id(PRIMARY)

---

## uni_application
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint | NO | PRI | NULL | 主键 |
| job_id | bigint | NO | MUL | NULL | 职位ID(uni_job.id) |
| user_id | bigint | NO | MUL | NULL | 投递人ID(uni_user.id) |
| resume_id | bigint | YES |  | NULL | 简历ID(uni_resume.id) |
| status | varchar(20) | NO |  | PENDING | 状态: PENDING-待查看 REVIEWING-已查看 ACCEPTED-已通过 REJECTED-已拒绝 |
| message | varchar(500) | YES |  | NULL | 求职留言 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: user_id(idx_user_id), id(PRIMARY), job_id(uk_job_user), user_id(uk_job_user)

---

## uni_chat
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint | NO | PRI | NULL | 主键 |
| user_a_id | bigint | NO | MUL | NULL | 用户A ID(uni_user.id) |
| user_b_id | bigint | NO |  | NULL | 用户B ID(uni_user.id) |
| business_type | varchar(20) | YES |  | NULL | 业务类型: JOB-岗位 PRODUCT-资源信息 |
| business_id | bigint | YES |  | NULL | 业务ID: 指向 uni_job.id 或 uni_product.id |
| last_message | varchar(500) | YES |  | NULL | 最后一条消息 |
| last_time | datetime | YES |  | NULL | 最后消息时间 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: id(PRIMARY), user_a_id(uk_users), user_b_id(uk_users)

---

## uni_chat_message
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint | NO | PRI | NULL | 主键 |
| chat_id | bigint | NO | MUL | NULL | 会话ID(uni_chat.id) |
| sender_id | bigint | NO |  | NULL | 发送者ID(uni_user.id) |
| receiver_id | bigint | NO | MUL | NULL | 接收者ID(uni_user.id) |
| content | varchar(1000) | YES |  | NULL | 消息内容 |
| content_type | varchar(10) | NO |  | TEXT | 消息类型: TEXT/IMAGE |
| read_status | tinyint | NO |  | 0 | 阅读状态: 0-未读 1-已读 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 发送时间 |

**索引**: chat_id(idx_chat_id), receiver_id(idx_receiver), read_status(idx_receiver), id(PRIMARY)

---

## uni_dynamic
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint | NO | PRI | NULL | 主键 |
| user_id | bigint | NO | MUL | NULL | 用户ID(uni_user.id) |
| type | varchar(20) | NO | MUL | NOTE | 类型: APPLICATION-投递 INTERVIEW-面试 FAVORITE-收藏 PRODUCT-商品 NOTE-个人发布 |
| title | varchar(100) | YES |  | NULL | 动态标题 |
| content | varchar(500) | YES |  | NULL | 动态内容 |
| related_id | bigint | YES |  | NULL | 关联业务ID |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |

**索引**: type(idx_type), user_id(idx_user_id), id(PRIMARY)

---

## uni_favorite
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint | NO | PRI | NULL | 主键 |
| user_id | bigint | NO | MUL | NULL | 用户ID(uni_user.id) |
| business_type | varchar(20) | YES |  | NULL | 业务类型: JOB-岗位 PRODUCT-资源信息 |
| business_id | bigint | YES |  | NULL | 业务ID: 指向 uni_job.id 或 uni_product.id |
| job_id | bigint | YES | MUL | NULL | 兼容旧字段: 岗位ID(收藏岗位时冗余) |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 收藏时间 |

**索引**: job_id(idx_job_id), id(PRIMARY), user_id(uk_user_job), job_id(uk_user_job)

---

## uni_interview
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint | NO | PRI | NULL | 主键 |
| application_id | bigint | YES |  | NULL | 投递记录ID(uni_application.id) |
| job_id | bigint | YES | MUL | NULL | 职位ID(uni_job.id) |
| company_user_id | bigint | YES |  | NULL | HR/发布人ID(uni_user.id) |
| user_id | bigint | NO | MUL | NULL | 面试者ID(uni_user.id) |
| company | varchar(100) | YES |  | NULL | 公司名称 |
| interview_time | datetime | YES |  | NULL | 面试时间 |
| location | varchar(200) | YES |  | NULL | 面试地点 |
| interviewer | varchar(50) | YES |  | NULL | 面试官 |
| contact_phone | varchar(20) | YES |  | NULL | 联系电话 |
| status | varchar(20) | NO |  | PENDING | 状态: PENDING-待确认 CONFIRMED-已确认 COMPLETED-已完成 CANCELLED-已取消 |
| remark | varchar(500) | YES |  | NULL | 备注 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: job_id(idx_job_id), user_id(idx_user_id), id(PRIMARY)

---

## uni_job
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint | NO | PRI | NULL | 主键 |
| title | varchar(100) | NO |  | NULL | 职位名称 |
| company | varchar(100) | YES |  | NULL | 公司名称 |
| company_logo | varchar(255) | YES |  | NULL | 公司Logo |
| location | varchar(100) | YES | MUL | NULL | 工作地点 |
| salary_min | decimal(10,2) | YES |  | NULL | 最低薪资(元/月) |
| salary_max | decimal(10,2) | YES |  | NULL | 最高薪资(元/月) |
| education | varchar(20) | YES |  | NULL | 学历要求 |
| experience | varchar(20) | YES |  | NULL | 经验要求 |
| type | varchar(20) | NO |  | FULL_TIME | 工作类型: FULL_TIME/PART_TIME/INTERNSHIP |
| tags | varchar(200) | YES |  | NULL | 标签(逗号分隔) |
| description | text | YES |  | NULL | 职位描述 |
| requirement | text | YES |  | NULL | 任职要求 |
| head_count | int | YES |  | 1 | 招聘人数 |
| work_time | varchar(64) | YES |  | NULL | 工作时间 |
| status | tinyint | NO | MUL | 1 | 状态: 1-招聘中 0-已下架 |
| publisher_id | bigint | YES | MUL | NULL | 发布人ID(uni_user.id) |
| view_count | int | NO |  | 0 | 浏览量 |
| apply_count | int | NO |  | 0 | 投递量 |
| favorite_count | int | NO |  | 0 | 收藏量 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: location(idx_location), publisher_id(idx_publisher_id), status(idx_status), id(PRIMARY)

---

## uni_product
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint | NO | PRI | NULL | 主键 |
| title | varchar(100) | NO |  | NULL | 商品标题 |
| item_type | varchar(20) | YES |  | EQUIPMENT | 资源类型: EQUIPMENT-二手设备 SHOP-门面出租/转让 |
| description | text | YES |  | NULL | 商品描述 |
| category | varchar(50) | YES | MUL | NULL | 分类 |
| price | decimal(10,2) | NO |  | 0.00 | 售价 |
| original_price | decimal(10,2) | YES |  | NULL | 原价 |
| image | varchar(500) | YES |  | NULL | 图片地址(逗号分隔) |
| condition | varchar(20) | YES |  | NULL | 成色: 全新/几乎全新/轻微使用/明显使用 |
| seller_id | bigint | YES | MUL | NULL | 卖家ID(uni_user.id) |
| status | tinyint | NO | MUL | 1 | 状态: 1-在售 0-已下架 2-已售出 |
| view_count | int | NO |  | 0 | 浏览量 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: category(idx_category), seller_id(idx_seller_id), status(idx_status), id(PRIMARY)

---

## uni_resume
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint | NO | PRI | NULL | 主键 |
| user_id | bigint | NO | MUL | NULL | 所属用户ID(uni_user.id) |
| title | varchar(100) | YES |  | NULL | 简历标题 |
| name | varchar(50) | YES |  | NULL | 姓名 |
| gender | tinyint | NO |  | 0 | 性别: 0-未知 1-男 2-女 |
| phone | varchar(20) | YES |  | NULL | 联系电话 |
| email | varchar(100) | YES |  | NULL | 邮箱 |
| birthday | varchar(20) | YES |  | NULL | 生日 |
| education | varchar(20) | YES |  | NULL | 学历 |
| school | varchar(100) | YES |  | NULL | 毕业院校 |
| major | varchar(100) | YES |  | NULL | 专业 |
| salary | varchar(32) | YES |  | NULL | 期望薪资 |
| location | varchar(64) | YES |  | NULL | 所在区域 |
| work_years | varchar(20) | YES |  | NULL | 工作经验 |
| skills | varchar(500) | YES |  | NULL | 技能特长 |
| experience | text | YES |  | NULL | 工作经历 |
| self_evaluation | text | YES |  | NULL | 自我评价 |
| status | tinyint | NO |  | 1 | 状态: 1-公开 0-私密 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: user_id(idx_user_id), id(PRIMARY)

---

## uni_user
| 字段 | 类型 | 可空 | 键 | 默认 | 说明 |
|---|---|---|---|---|---|
| id | bigint | NO | PRI | NULL | 主键 |
| username | varchar(50) | NO | UNI | NULL | 登录账号 |
| password | varchar(100) | NO |  | NULL | 密码(BCrypt加密) |
| nickname | varchar(50) | YES |  | NULL | 昵称 |
| avatar | varchar(255) | YES |  | NULL | 头像地址 |
| phone | varchar(20) | YES |  | NULL | 手机号 |
| gender | tinyint | NO |  | 0 | 性别: 0-未知 1-男 2-女 |
| birthday | varchar(20) | YES |  | NULL | 生日 |
| city | varchar(50) | YES |  | NULL | 所在城市 |
| role | varchar(20) | NO |  | SEEKER | 角色: SEEKER-求职者 SELLER-卖家 |
| status | tinyint | NO |  | 1 | 状态: 1-正常 0-禁用 |
| create_time | datetime | NO |  | CURRENT_TIMESTAMP | 创建时间 |
| update_time | datetime | NO |  | CURRENT_TIMESTAMP | 更新时间 |

**索引**: id(PRIMARY), username(uk_username)