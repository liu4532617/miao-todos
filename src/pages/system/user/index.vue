<template>
  <div class="user-page">
    <h2>用户管理</h2>

    <!-- 搜索栏 -->
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="query" @submit.prevent>
        <el-form-item label="用户名">
          <el-input v-model="query.username" placeholder="请输入" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="query.status" placeholder="请选择" clearable>
            <el-option label="启用" :value="1" />
            <el-option label="禁用" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 工具栏 -->
    <div class="toolbar">
      <el-button type="primary" @click="openDialog()">新增用户</el-button>
    </div>

    <!-- 用户列表 -->
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="username" label="用户名" />
      <el-table-column prop="nickname" label="昵称" />
      <el-table-column prop="email" label="邮箱" />
      <el-table-column label="状态" width="90">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'danger'">
            {{ row.status === 1 ? '启用' : '禁用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="180" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="openDialog(row)">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑用户' : '新增用户'" width="480px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="用户名" prop="username">
          <el-input v-model="form.username" placeholder="请输入用户名" :disabled="isEdit" />
        </el-form-item>
        <el-form-item label="密码" prop="password">
          <el-input v-model="form.password" type="password" show-password
            :placeholder="isEdit ? '留空则不修改' : '请输入密码'" />
        </el-form-item>
        <el-form-item label="昵称" prop="nickname">
          <el-input v-model="form.nickname" placeholder="请输入昵称" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">启用</el-radio>
            <el-radio :value="0">禁用</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitting" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
/** 用户管理 - 系统用户列表与维护 */
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { userApi } from '../../../api/system'
import type { SysUser } from '../../../types/entity'

/** 搜索条件 */
const query = reactive({ username: '', status: undefined as number | undefined })

/** 列表数据 */
const list = ref<SysUser[]>([])
const loading = ref(false)

/** 加载列表 */
async function loadList() {
  loading.value = true
  try {
    list.value = await userApi.list({
      username: query.username || undefined,
      status: query.status,
    })
  } finally {
    loading.value = false
  }
}

/** 查询 */
function handleSearch() {
  loadList()
}

/** 重置查询条件 */
function handleReset() {
  query.username = ''
  query.status = undefined
  loadList()
}

/* ========== 新增 / 编辑 ========== */
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitting = ref(false)
const formRef = ref<FormInstance>()

/** 表单数据 */
const form = reactive<Partial<SysUser>>({
  username: '',
  password: '',
  nickname: '',
  email: '',
  phone: '',
  status: 1,
})

/** 表单校验规则 */
const rules: FormRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [
    { validator: (_rule, value, cb) => {
        if (!isEdit.value && !value) return cb(new Error('请输入密码'))
        cb()
      }, trigger: 'blur' },
  ],
}

/** 打开新增/编辑对话框 */
function openDialog(row?: SysUser) {
  isEdit.value = !!row
  if (row) {
    Object.assign(form, {
      id: row.id,
      username: row.username,
      password: '',
      nickname: row.nickname,
      email: row.email,
      phone: row.phone,
      status: row.status ?? 1,
    })
  } else {
    Object.assign(form, { id: undefined, username: '', password: '', nickname: '', email: '', phone: '', status: 1 })
  }
  dialogVisible.value = true
}

/** 提交保存 */
async function handleSubmit() {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  submitting.value = true
  try {
    if (isEdit.value) {
      // 编辑：密码留空时不传 password
      const { password, ...rest } = form
      const data = password ? form : rest
      await userApi.update(data as SysUser)
      ElMessage.success('更新成功')
    } else {
      await userApi.add(form as SysUser)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    loadList()
  } catch {
    // 错误已由拦截器统一提示
  } finally {
    submitting.value = false
  }
}

/* ========== 删除 ========== */
async function handleDelete(row: SysUser) {
  await ElMessageBox.confirm(`确定删除用户「${row.username}」吗？`, '提示', { type: 'warning' })
  try {
    await userApi.remove(row.id!)
    ElMessage.success('删除成功')
    loadList()
  } catch {
    // 取消或失败
  }
}

onMounted(loadList)
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.search-card { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
