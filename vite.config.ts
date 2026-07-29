import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vite.dev/config/
export default defineConfig({
    plugins: [vue()],

    server: {
        proxy: {
            '/api': {
                target: 'http://localhost:3000',
                changeOrigin: true,
                rewrite: (path) => path.replace(/^\/api/, ''),
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
