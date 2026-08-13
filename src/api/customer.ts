import http from '../http/index'
import type { ApiResponse } from '../http/types'
import type { CrmCustomer } from '../types/entity'

/** 客户管理接口前缀（对应后端 /api/customer） */
const BASE = '/customer'

/** 客户列表（支持条件过滤：名称/电话/来源/级别/状态/负责人） */
export function fetchCustomerList(params?: Partial<CrmCustomer>): Promise<CrmCustomer[]> {
  return http
    .get<ApiResponse<CrmCustomer[]>>(BASE + '/list', { params })
    .then((res) => res.data.data)
}

/** 客户详情 */
export function fetchCustomerById(id: number): Promise<CrmCustomer> {
  return http.get<ApiResponse<CrmCustomer>>(`${BASE}/${id}`).then((res) => res.data.data)
}

/** 新增客户 */
export function createCustomer(data: CrmCustomer): Promise<void> {
  return http.post<ApiResponse<null>>(BASE, data).then(() => undefined)
}

/** 更新客户 */
export function updateCustomer(data: CrmCustomer): Promise<void> {
  return http.put<ApiResponse<null>>(BASE, data).then(() => undefined)
}

/** 删除客户 */
export function deleteCustomer(id: number): Promise<void> {
  return http.delete<ApiResponse<null>>(`${BASE}/${id}`).then(() => undefined)
}
