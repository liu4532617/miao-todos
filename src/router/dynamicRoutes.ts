import type { RouteRecordRaw } from 'vue-router'
import type { BackendRouteRecord } from '../types/route'
import { loadPageComponent } from './componentLoader'

export function backendRoutesToRecords(routes: BackendRouteRecord[]): RouteRecordRaw[] {
  return routes.map(toRouteRecord)
}

function toRouteRecord(route: BackendRouteRecord): RouteRecordRaw {
  return {
    path: route.path,
    name: route.name,
    component: route.component ? loadPageComponent(route.component) : undefined,
    children: route.children?.length ? route.children.map(toRouteRecord) : undefined,
    meta: route.meta,
  } as RouteRecordRaw
}
