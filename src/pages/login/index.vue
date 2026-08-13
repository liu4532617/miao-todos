<template>
  <div class="login-container">
    <div class="login-card">
      <h2 class="login-title">CRM 管理系统</h2>
      <el-form
        ref="formRef"
        :model="form"
        :rules="rules"
        label-width="0"
        size="large"
        @keyup.enter="handleLogin"
      >
        <el-form-item prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" :prefix-icon="User" />
        </el-form-item>
        <el-form-item prop="password">
          <el-input
            v-model="form.password"
            type="password"
            placeholder="请输入密码"
            :prefix-icon="Lock"
            show-password
          />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" :loading="loading" class="login-btn" @click="handleLogin">
            登 录
          </el-button>
        </el-form-item>
      </el-form>
      <div class="login-tip">
        测试账号：admin / admin123
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'
import { User, Lock } from '@element-plus/icons-vue'
import { ElMessage } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { loginApi } from '../../api/auth'

/** 登录表单数据 */
const form = reactive({
  username: '',
  password: '',
})

/** 登录表单校验规则 */
const rules: FormRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度至少 6 位', trigger: 'blur' },
  ],
}

const formRef = ref<FormInstance>()
const loading = ref(false)

/** 登录 */
async function handleLogin() {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  loading.value = true
  try {
    // 对接真实登录接口：成功后保存 token
    const res = await loginApi({ username: form.username, password: form.password })
    localStorage.setItem('token', res.token)

    ElMessage.success('登录成功')
    // 跳转首页并重新加载：此时 token 已保存，bootstrap 重新执行，
    // /sys/menu/menus 能带上 token 返回真实菜单，路由表按用户角色动态构建
    window.location.href = '/'
  } catch {
    // 登录失败由拦截器统一处理
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-container {
  height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.login-card {
  width: 400px;
  padding: 40px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.15);
}

.login-title {
  text-align: center;
  margin-bottom: 30px;
  color: #303133;
  font-size: 24px;
}

.login-btn {
  width: 100%;
}

.login-tip {
  text-align: center;
  color: #909399;
  font-size: 12px;
  margin-top: 16px;
}
</style>
