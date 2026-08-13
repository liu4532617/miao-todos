import type { BackendRouteRecord } from '../types/route'

/**
 * 本地兜底路由配置
 * 当后端 /routes 接口不可用或返回数据为空时使用
 */
export const fallbackRouteConfig: BackendRouteRecord[] = [
    /* ========== 登录页（不含布局） ========== */
    {
        path: '/login',
        name: 'login',
        component: 'login/index',
    },

    /* ========== 主布局（带侧边栏+顶栏） ========== */
    {
        path: '/',
        name: 'layout',
        component: 'layout/index',
        children: [
            // 工作台
            { path: '', name: 'dashboard', component: 'dashboard/index', meta: { title: '工作台', icon: 'Odometer' } },

            // 业务模块
            // { path: 'customer', name: 'customer', component: 'customer/index', meta: { title: '客户管理', group: '业务管理' } },
            // { path: 'customer/:id', name: 'customerDetail', component: 'customer/detail', meta: { group: '业务管理' } },
            // { path: 'clue', name: 'clue', component: 'clue/index', meta: { title: '线索管理', group: '业务管理' } },
            // { path: 'clue/:id', name: 'clueDetail', component: 'clue/detail', meta: { group: '业务管理' } },
            // { path: 'task-list', name: 'taskList', component: 'tasks/index', meta: { title: '任务管理', group: '业务管理' } },
            // { path: 'task/:id', name: 'task', component: 'task/index', meta: { group: '业务管理' } },
            // { path: 'knowledge', name: 'knowledge', component: 'knowledge/index', meta: { title: '知识库', group: '业务管理' } },
            // { path: 'knowledge/:id', name: 'knowledgeDetail', component: 'knowledge/detail', meta: { group: '业务管理' } },
            // { path: 'order', name: 'order', component: 'order/index', meta: { title: '订单管理', group: '业务管理' } },
            // { path: 'order/:id', name: 'orderDetail', component: 'order/detail', meta: { group: '业务管理' } },
            // { path: 'product', name: 'product', component: 'product/index', meta: { title: '产品管理', group: '业务管理' } },
            // { path: 'product/:id', name: 'productDetail', component: 'product/detail', meta: { group: '业务管理' } },

            // 系统管理
            { path: 'system/user', name: 'systemUser', component: 'system/user/index', meta: { title: '用户管理', group: '系统管理' } },
            { path: 'system/role', name: 'systemRole', component: 'system/role/index', meta: { title: '角色管理', group: '系统管理' } },
            { path: 'system/permission', name: 'systemPermission', component: 'system/permission/index', meta: { title: '权限管理', group: '系统管理' } },
            { path: 'system/menu', name: 'systemMenu', component: 'system/menu/index', meta: { title: '菜单资源', group: '系统管理' } },
        ],
    },

    /* ========== 错误页面 ========== */
    { path: '/403', name: 'error403', component: 'error/403' },
    { path: '/404', name: 'error404', component: 'error/404' },
    { path: '/500', name: 'error500', component: 'error/500' },

    /* ========== 通配符 404（所有未匹配路径） ========== */
    { path: '/:pathMatch(.*)*', name: 'notFound', component: 'error/404' },
]
