import { defineStore } from "pinia";
import { ref } from "vue";
import { fetchTasks, createTask, deleteTask, type Task } from "../api/task";

export const useTaskStore = defineStore('task', () => {
  /** 任务列表（响应式） */
  const tasks = ref<Task[]>([]);

  /** 加载状态 */
  const loading = ref(false);

  /** 从后端加载任务列表 */
  async function loadTasks() {
    loading.value = true;
    try {
      tasks.value = await fetchTasks();
    } catch {
      // 后端不可用时保持空列表
      tasks.value = [];
    } finally {
      loading.value = false;
    }
  }

  /** 添加任务（本地同步） */
  const handAdd = (taskName: string) => {
    tasks.value.push({ id: tasks.value.length, name: taskName });
  };

  /** 删除任务（本地同步） */
  const handDel = (index: number) => {
    tasks.value.splice(index, 1);
  };

  /** 添加任务（走 API） */
  async function addTask(name: string): Promise<void> {
    const task = await createTask(name);
    tasks.value.push(task);
  }

  /** 删除任务（走 API） */
  async function removeTask(id: number): Promise<void> {
    await deleteTask(id);
    const idx = tasks.value.findIndex((t) => t.id === id);
    if (idx !== -1) tasks.value.splice(idx, 1);
  }

  return {
    tasks,
    loading,
    loadTasks,
    handAdd,
    handDel,
    addTask,
    removeTask,
  };
});
