import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
    plugins: [vue()],

    server: {
        proxy: {
            '/api': {
                // 后端 Spring Boot 服务地址（接口自带 /api 前缀，无需 rewrite）
                target: 'http://localhost:8080',
                changeOrigin: true,
            },
        },
    },

    //打包配置  可以把配置打包到一个js 优化请求 提高页面请求速度
    build: {
        rollupOptions: {
            output: {
                manualChunks(id) {
                    // id 是文件的绝对路径
                    if (id.includes('node_modules/vue')
                        || id.includes('node_modules/vue-router')
                        || id.includes('node_modules/pinia')) {
                        return 'vue'
                    }
                }
            }
        }
    }
})
