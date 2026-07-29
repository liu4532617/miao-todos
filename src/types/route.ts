/** 后端返回的单条路由配置（component 相对 src/pages，不含 .vue） */
export interface BackendRouteRecord {
  path: string
  name: string
  component: string
  meta?: Record<string, unknown>
  children?: BackendRouteRecord[]
}
