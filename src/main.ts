import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import { setupAndGetRouter } from './router'
import { useTaskStore } from './stores/task'

async function bootstrap() {
  const app = createApp(App)
  const pinia = createPinia()

  app.use(pinia)
  app.use(ElementPlus)

  // 1. 先获取路由数据，再创建路由器（此时路由表已完整）
  const router = await setupAndGetRouter()
  app.use(router)

  await router.isReady()

  // 2. 尝试从后端加载任务列表
  const taskStore = useTaskStore()
  taskStore.loadTasks()

  app.mount('#app')
}

bootstrap()
