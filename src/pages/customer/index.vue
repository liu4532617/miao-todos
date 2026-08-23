<template>
  <div class="customer-page">
    <h2>客户管理</h2>
    <!-- 搜索栏 -->
    <el-card shadow="never" class="search-card">
      <el-form :inline="true" :model="query">
        <el-form-item label="客户名称">
          <el-input v-model="query.name" placeholder="请输入" clearable />
        </el-form-item>
        <el-form-item label="联系电话">
          <el-input v-model="query.phone" placeholder="请输入" clearable />
        </el-form-item>
        <el-form-item label="客户等级">
          <el-select v-model="query.level" placeholder="请选择" clearable>
            <el-option label="普通" :value="1" />
            <el-option label="重要" :value="2" />
            <el-option label="VIP" :value="3" />
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
      <el-button type="primary" @click="handleAdd">新增客户</el-button>
    </div>

    <!-- 客户列表 -->
    <el-table :data="list" border stripe v-loading="loading">
      <el-table-column prop="id" label="ID" width="80" />
      <el-table-column prop="name" label="客户名称" />
      <el-table-column prop="phone" label="联系电话" />
      <el-table-column prop="company" label="公司名称" show-overflow-tooltip />
      <el-table-column label="等级" width="90">
        <template #default="{ row }">
          <el-tag :type="levelTagType(row.level)">{{ levelText(row.level) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="90">
        <template #default="{ row }">
          <el-tag :type="row.status === 2 ? 'success' : row.status === 0 ? 'danger' : 'primary'">
            {{ statusText(row.status) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="180" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="handleEdit(row)">编辑</el-button>
          <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="form.id ? '编辑客户' : '新增客户'" width="520px">
      <el-form :model="form" label-width="90px">
        <el-form-item label="客户名称" required>
          <el-input v-model="form.name" placeholder="请输入客户名称" />
        </el-form-item>
        <el-form-item label="联系电话">
          <el-input v-model="form.phone" placeholder="请输入联系电话" />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input v-model="form.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="公司名称">
          <el-input v-model="form.company" placeholder="请输入公司名称" />
        </el-form-item>
        <el-form-item label="地址">
          <el-input v-model="form.address" placeholder="请输入地址" />
        </el-form-item>
        <el-form-item label="客户等级">
          <el-select v-model="form.level" placeholder="请选择">
            <el-option label="普通" :value="1" />
            <el-option label="重要" :value="2" />
            <el-option label="VIP" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select v-model="form.status" placeholder="请选择">
            <el-option label="流失" :value="0" />
            <el-option label="跟进中" :value="1" />
            <el-option label="已成交" :value="2" />
          </el-select>
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="form.remark" type="textarea" :rows="2" placeholder="备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="saving" @click="handleSave">保存</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
/** 客户列表页（对接 /api/customer） */
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import http from '../../http/index'

interface Customer {
  id: number
  name: string
  phone: string
  email: string
  company: string
  address: string
  source: string
  level: number
  status: number
  remark: string
  createTime: string
}

/** 搜索条件 */
const query = reactive({ name: '', phone: '', level: undefined as number | undefined })

/** 列表数据 */
const list = ref<Customer[]>([])
const loading = ref(false)

/** 新增/编辑对话框 */
const dialogVisible = ref(false)
const saving = ref(false)
const form = reactive<Partial<Customer>>({})

function levelText(level?: number) {
  return level === 3 ? 'VIP' : level === 2 ? '重要' : '普通'
}
function levelTagType(level?: number) {
  return level === 3 ? 'danger' : level === 2 ? 'warning' : 'info'
}
function statusText(status?: number) {
  return status === 2 ? '已成交' : status === 0 ? '流失' : '跟进中'
}

/** 加载客户列表 */
async function loadList() {
  loading.value = true
  try {
    const res = await http.get('/customer/list', { params: query })
    list.value = res.data.data || []
  } catch (err: any) {
    ElMessage.error(err?.message || '加载客户列表失败')
  } finally {
    loading.value = false
  }
}

function handleSearch() {
  loadList()
}

function handleReset() {
  query.name = ''
  query.phone = ''
  query.level = undefined
  loadList()
}

function handleAdd() {
  Object.keys(form).forEach((k) => delete form[k as keyof Customer])
  form.level = 1
  form.status = 1
  dialogVisible.value = true
}

function handleEdit(row: Customer) {
  Object.assign(form, row)
  dialogVisible.value = true
}

async function handleSave() {
  if (!form.name) {
    ElMessage.warning('客户名称不能为空')
    return
  }
  saving.value = true
  try {
    if (form.id) {
      await http.put('/customer', form)
      ElMessage.success('更新成功')
    } else {
      await http.post('/customer', form)
      ElMessage.success('新增成功')
    }
    dialogVisible.value = false
    loadList()
  } catch (err: any) {
    ElMessage.error(err?.message || '保存失败')
  } finally {
    saving.value = false
  }
}

async function handleDelete(row: Customer) {
  try {
    await ElMessageBox.confirm(`确定删除客户「${row.name}」吗？`, '提示', { type: 'warning' })
  } catch {
    return
  }
  try {
    await http.delete(`/customer/${row.id}`)
    ElMessage.success('删除成功')
    loadList()
  } catch (err: any) {
    ElMessage.error(err?.message || '删除失败')
  }
}

onMounted(loadList)
</script>

<style scoped>
h2 { margin-bottom: 16px; }
.search-card { margin-bottom: 16px; }
.toolbar { margin-bottom: 16px; }
</style>
