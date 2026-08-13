<template>
  <div class="customer-page">
    <h2>客户管理</h2>

    <!-- 搜索栏 -->
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="query" @submit.prevent>
        <el-form-item label="客户名称">
          <el-input v-model="query.name" placeholder="请输入" clearable @keyup.enter="handleSearch" />
        </el-form-item>
        <el-form-item label="客户等级">
          <el-select v-model="query.level" placeholder="请选择" clearable>
            <el-option label="普通" :value="1" />
            <el-option label="重要" :value="2" />
            <el-option label="VIP" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="query.status" placeholder="请选择" clearable>
            <el-option label="跟进中" :value="1" />
            <el-option label="已成交" :value="2" />
            <el-option label="已流失" :value="0" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSearch">查询</el-button>
          <el-button @click="handleReset">重置</el-button>
        </el-form-item>
      </el-form>
    </el-card>

    <!-- 表格工具栏 -->
    <div class="toolbar">
      <el-button type="primary" @click="openDialog()">新增客户</el-button>
    </div>

    <!-- 客户列表 -->
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="客户名称" />
      <el-table-column prop="phone" label="联系电话" />
      <el-table-column prop="company" label="公司" />
      <el-table-column label="等级" width="90">
        <template #default="{ row }">
          <el-tag :type="levelTag(row.level)">{{ levelLabel(row.level) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="90">
        <template #default="{ row }">
          <el-tag :type="statusTag(row.status)">{{ statusLabel(row.status) }}</el-tag>
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
    <el-dialog v-model="dialogVisible" :title="isEdit ? '编辑客户' : '新增客户'" width="520px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="80px">
        <el-form-item label="客户名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入客户名称" />
        </el-form-item>
        <el-form-item label="联系电话" prop="phone">
          <el-input v-model="form.phone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="公司" prop="company">
          <el-input v-model="form.company" placeholder="请输入公司名称" />
        </el-form-item>
        <el-form-item label="地址" prop="address">
          <el-input v-model="form.address" placeholder="请输入地址" />
        </el-form-item>
        <el-form-item label="客户等级" prop="level">
          <el-radio-group v-model="form.level">
            <el-radio :value="1">普通</el-radio>
            <el-radio :value="2">重要</el-radio>
            <el-radio :value="3">VIP</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">跟进中</el-radio>
            <el-radio :value="2">已成交</el-radio>
            <el-radio :value="0">已流失</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="备注" prop="remark">
          <el-input v-model="form.remark" type="textarea" :rows="2" placeholder="请输入备注" />
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
/** 客户列表页 */
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { fetchCustomerList, createCustomer, updateCustomer, deleteCustomer } from '../../api/customer'
import type { CrmCustomer } from '../../types/entity'

/** 搜索条件 */
const query = reactive({ name: '', level: undefined as number | undefined, status: undefined as number | undefined })

/** 列表数据 */
const list = ref<CrmCustomer[]>([])
const loading = ref(false)

/** 加载列表 */
async function loadList() {
  loading.value = true
  try {
    list.value = await fetchCustomerList({
      name: query.name || undefined,
      level: query.level,
      status: query.status,
    })
  } finally {
    loading.value = false
  }
}

function handleSearch() { loadList() }

function handleReset() {
  query.name = ''
  query.level = undefined
  query.status = undefined
  loadList()
}

/** 等级/状态显示 */
function levelLabel(level?: number) { return { 1: '普通', 2: '重要', 3: 'VIP' }[level ?? 0] ?? '未知' }
function levelTag(level?: number) { return { 1: 'info', 2: 'warning', 3: 'danger' }[level ?? 0] ?? 'info' }
function statusLabel(status?: number) { return { 0: '已流失', 1: '跟进中', 2: '已成交' }[status ?? -1] ?? '未知' }
function statusTag(status?: number) { return { 0: 'danger', 1: 'primary', 2: 'success' }[status ?? -1] ?? 'info' }

/* ========== 新增 / 编辑 ========== */
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitting = ref(false)
const formRef = ref<FormInstance>()

const form = reactive<Partial<CrmCustomer>>({
  name: '',
  phone: '',
  email: '',
  company: '',
  address: '',
  level: 1,
  status: 1,
  remark: '',
})

const rules: FormRules = {
  name: [{ required: true, message: '请输入客户名称', trigger: 'blur' }],
}

function openDialog(row?: CrmCustomer) {
  isEdit.value = !!row
  if (row) {
    Object.assign(form, {
      id: row.id, name: row.name, phone: row.phone, email: row.email,
      company: row.company, address: row.address, level: row.level ?? 1,
      status: row.status ?? 1, remark: row.remark,
    })
  } else {
    Object.assign(form, {
      id: undefined, name: '', phone: '', email: '', company: '',
      address: '', level: 1, status: 1, remark: '',
    })
  }
  dialogVisible.value = true
}

async function handleSubmit() {
  const valid = await formRef.value?.validate().catch(() => false)
  if (!valid) return

  submitting.value = true
  try {
    if (isEdit.value) {
      await updateCustomer(form as CrmCustomer)
      ElMessage.success('更新成功')
    } else {
      await createCustomer(form as CrmCustomer)
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
async function handleDelete(row: CrmCustomer) {
  await ElMessageBox.confirm(`确定删除客户「${row.name}」吗？`, '提示', { type: 'warning' })
  try {
    await deleteCustomer(row.id!)
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
