import { useTaskStore } from "../stores/task"

export const userCurrentTask = (id: number) => {
    const taskStore = useTaskStore();
    const task = taskStore.tasks.find((task) => task.id === id);
    return task;
}