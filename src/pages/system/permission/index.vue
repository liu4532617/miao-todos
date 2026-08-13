<template>
  <div class="permission-page">
    <h2>权限管理</h2>

    <!-- 搜索栏 -->
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="query" @submit.prevent>
        <el-form-item label="权限名称">
          <el-input v-model="query.name" placeholder="请输入" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <div class="toolbar">
      <el-button type="primary" @click="openDialog()">新增权限</el-button>
    </div>

    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="权限名称" />
      <el-table-column prop="code" label="权限标识" />
      <el-table-column prop="description" label="描述" />
      <el-table-column label="操作" width="150" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="openDialog(row)">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑权限' : '新增权限'" width="480px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="权限名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入权限名称" />
        </el-form-item>
        <el-form-item label="权限标识" prop="code">
          <el-input v-model="form.code" placeholder="如 customer:create" :disabled="isEdit" />
        </el-form-item>
        <el-form-item label="描述" prop="description">
          <el-input v-model="form.description" type="textarea" :rows="2" placeholder="请输入描述" />
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
/** 权限管理 - 系统权限点定义 */
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { permissionApi } from '../../../api/system'
import type { SysPermission } from '../../../types/entity'

/** 搜索条件 */
const query = reactive({ name: '' })

/** 列表数据 */
const list = ref<SysPermission[]>([])
const loading = ref(false)

/** 加载列表 */
async function loadList() {
  loading.value = true
  try {
    list.value = await permissionApi.list({ name: query.name || undefined })
  } finally {
    loading.value = false
  }
}

function handleSearch() { loadList() }

function handleReset() {
  query.name = ''
  loadList()
}

/* ========== 新增 / 编辑 ========== */
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitting = ref(false)
const formRef = ref<FormInstance>()

const form = reactive<Partial<SysPermission>>({
  name: '',
  code: '',
  description: '',
})

const rules: FormRules = {
  name: [{ required: true, message: '请输入权限名称', trigger: 'blur' }],
  code: [{ required: true, message: '请输入权限标识', trigger: 'blur' }],
}

function openDialog(row?: SysPermission) {
  isEdit.value = !!row
  if (row) {
    Object.assign(form, { id: row.id, name: row.name, code: row.code, description: row.description })
  } else {
    Object.assign(form, { id: undefined, name: '', code: '', description: '' })
  }
  dialogVisible.value = true
}

async function handleSubmit() {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  submitting.value = true
  try {
    if (isEdit.value) {
      await permissionApi.update(form as SysPermission)
      ElMessage.success('更新成功')
    } else {
      await permissionApi.add(form as SysPermission)
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
async function handleDelete(row: SysPermission) {
  await ElMessageBox.confirm(`确定删除权限「${row.name}」吗？`, '提示', { type: 'warning' })
  try {
    await permissionApi.remove(row.id!)
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
