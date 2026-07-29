import { defineAsyncComponent, type Component } from 'vue'

const pageModules = import.meta.glob('../pages/**/*.vue')

export function loadPageComponent(relativePath: string): Component {
  const key = `../pages/${relativePath}.vue`
  const loader = pageModules[key]

  if (!loader) {
    throw new Error(`未找到页面组件: ${relativePath}`)
  }

  return defineAsyncComponent(loader as () => Promise<{ default: Component }>)
}
