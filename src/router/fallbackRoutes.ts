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
            { path: '', name: 'dashboard', component: 'dashboard/index' },

            // 业务模块
            { path: 'customer', name: 'customer', component: 'customer/index' },
            { path: 'customer/:id', name: 'customerDetail', component: 'customer/detail' },
            { path: 'clue', name: 'clue', component: 'clue/index' },
            { path: 'clue/:id', name: 'clueDetail', component: 'clue/detail' },
            { path: 'task-list', name: 'taskList', component: 'tasks/index' },
            { path: 'task/:id', name: 'task', component: 'task/index' },
            { path: 'knowledge', name: 'knowledge', component: 'knowledge/index' },
            { path: 'knowledge/:id', name: 'knowledgeDetail', component: 'knowledge/detail' },
            { path: 'order', name: 'order', component: 'order/index' },
            { path: 'order/:id', name: 'orderDetail', component: 'order/detail' },
            { path: 'product', name: 'product', component: 'product/index' },
            { path: 'product/:id', name: 'productDetail', component: 'product/detail' },

            // 系统管理
            { path: 'system/user', name: 'systemUser', component: 'system/user/index' },
            { path: 'system/role', name: 'systemRole', component: 'system/role/index' },
            { path: 'system/permission', name: 'systemPermission', component: 'system/permission/index' },
            { path: 'system/menu', name: 'systemMenu', component: 'system/menu/index' },
        ],
    },

    /* ========== 错误页面 ========== */
    { path: '/404', name: 'error404', component: 'error/404' },
    { path: '/500', name: 'error500', component: 'error/500' },

    /* ========== 通配符 404（所有未匹配路径） ========== */
    { path: '/:pathMatch(.*)*', name: 'notFound', component: 'error/404' },
]
