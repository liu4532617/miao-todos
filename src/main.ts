import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import { createPinia } from 'pinia'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import { setupAndGetRouter } from './router'

async function bootstrap() {
  const app = createApp(App)
  const pinia = createPinia()

  app.use(pinia)
  app.use(ElementPlus)

  // 1. 先获取路由数据，再创建路由器（此时路由表已完整）
  const router = await setupAndGetRouter()
  app.use(router)

  await router.isReady()

  app.mount('#app')
}

bootstrap()
