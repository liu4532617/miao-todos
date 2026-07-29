/** 后端统一响应格式 */
export interface ApiResponse<T = unknown> {
  code: number
  message: string
  data: T
}

/** 分页响应 */
export interface PaginatedData<T> {
  list: T[]
  total: number
  page: number
  pageSize: number
}
