import http from '../http/index'

/** 任务数据模型 */
export interface Task {
  id: number
  name: string
  createdAt?: string
}

const BASE = '/tasks'

/** 获取任务列表 */
export function fetchTasks(): Promise<Task[]> {
  return http.get<Task[]>(BASE).then((res) => res.data)
}

/** 获取单个任务 */
export function fetchTaskById(id: number): Promise<Task> {
  return http.get<Task>(`${BASE}/${id}`).then((res) => res.data)
}

/** 创建任务 */
export function createTask(name: string): Promise<Task> {
  return http.post<Task>(BASE, { name }).then((res) => res.data)
}

/** 删除任务 */
export function deleteTask(id: number): Promise<void> {
  return http.delete(`${BASE}/${id}`)
}
