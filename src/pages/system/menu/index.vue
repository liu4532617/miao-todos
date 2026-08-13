<template>
  <div class="menu-page">
    <h2>菜单资源管理</h2>

    <div class="toolbar">
      <el-button type="primary" @click="openDialog()">新增菜单</el-button>
    </div>

    <el-table
      :data="treeData"
      border
      stripe
      row-key="id"
      default-expand-all
      :tree-props="{ children: 'children' }"
      v-loading="loading"
    >
      <el-table-column prop="name" label="菜单名称" />
      <el-table-column prop="icon" label="图标" width="100" />
      <el-table-column prop="path" label="路由路径" />
      <el-table-column prop="component" label="组件路径" />
      <el-table-column label="类型" width="90">
        <template #default="{ row }">
          <el-tag :type="typeTag(row.type)">{{ typeLabel(row.type) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="sort" label="排序" width="80" />
      <el-table-column label="状态" width="80">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'info'" size="small">
            {{ row.status === 1 ? '显示' : '隐藏' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" link @click="openDialog(row)">编辑</el-button>
          <el-button type="primary" link @click="openDialog(undefined, row.id)">新增子菜单</el-button>
          <el-button type="danger" link @click="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 新增/编辑对话框 -->
    <el-dialog v-model="dialogVisible" :title="dialogTitle" width="520px">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="父菜单" prop="parentId">
          <el-tree-select
            v-model="form.parentId"
            :data="parentOptions"
            :props="{ label: 'name', children: 'children', value: 'id' }"
            check-strictly
            clearable
            placeholder="不选则为顶级菜单"
            node-key="id"
            style="width: 100%"
          />
        </el-form-item>
        <el-form-item label="菜单名称" prop="name">
          <el-input v-model="form.name" placeholder="请输入菜单名称" />
        </el-form-item>
        <el-form-item label="菜单类型" prop="type">
          <el-radio-group v-model="form.type">
            <el-radio :value="1">目录</el-radio>
            <el-radio :value="2">菜单</el-radio>
            <el-radio :value="3">按钮</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="路由路径" prop="path">
          <el-input v-model="form.path" placeholder="如 /customer" />
        </el-form-item>
        <el-form-item label="组件路径" prop="component">
          <el-input v-model="form.component" placeholder="如 customer/index" />
        </el-form-item>
        <el-form-item label="图标" prop="icon">
          <el-input v-model="form.icon" placeholder="图标类名" />
        </el-form-item>
        <el-form-item label="权限标识" prop="permission">
          <el-input v-model="form.permission" placeholder="如 customer:list" />
        </el-form-item>
        <el-form-item label="排序" prop="sort">
          <el-input-number v-model="form.sort" :min="0" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio :value="1">显示</el-radio>
            <el-radio :value="0">隐藏</el-radio>
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
/** 菜单资源管理 - 管理后台侧边栏菜单的层级结构 */
import { ref, reactive, computed, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, FormRules } from 'element-plus'
import { menuApi } from '../../../api/system'
import type { SysMenu } from '../../../types/entity'

/** 扁平列表 */
const flatList = ref<SysMenu[]>([])
/** 树形列表 */
const treeData = ref<SysMenu[]>([])
const loading = ref(false)

/** 加载菜单列表并组装成树 */
async function loadList() {
  loading.value = true
  try {
    flatList.value = await menuApi.list()
    treeData.value = buildTree(flatList.value)
  } finally {
    loading.value = false
  }
}

/** 扁平数组 → 树形结构 */
function buildTree(list: SysMenu[]): SysMenu[] {
  const map = new Map<number, SysMenu>()
  const roots: SysMenu[] = []

  list.forEach((item) => {
    map.set(item.id!, { ...item, children: [] })
  })
  list.forEach((item) => {
    const node = map.get(item.id!)!
    if (item.parentId != null && map.has(item.parentId)) {
      map.get(item.parentId)!.children!.push(node)
    } else {
      roots.push(node)
    }
  })
  return roots
}

/** 菜单类型显示 */
function typeLabel(type?: number) {
  return { 1: '目录', 2: '菜单', 3: '按钮' }[type ?? 0] ?? '未知'
}
function typeTag(type?: number) {
  return { 1: 'warning', 2: 'success', 3: 'info' }[type ?? 0] ?? 'info'
}

/* ========== 新增 / 编辑 ========== */
const dialogVisible = ref(false)
const isEdit = ref(false)
const submitting = ref(false)
const formRef = ref<FormInstance>()
const dialogTitle = computed(() => (isEdit.value ? '编辑菜单' : form.parentId ? '新增子菜单' : '新增菜单'))

const form = reactive<Partial<SysMenu>>({
  parentId: undefined,
  name: '',
  type: 2,
  path: '',
  component: '',
  icon: '',
  permission: '',
  sort: 0,
  status: 1,
})

const rules: FormRules = {
  name: [{ required: true, message: '请输入菜单名称', trigger: 'blur' }],
}

/** 父菜单选择树（不含当前编辑项自身） */
const parentOptions = computed<SysMenu[]>(() => {
  const excludeId = form.id
  const filter = (nodes: SysMenu[]): SysMenu[] =>
    nodes
      .filter((n) => n.id !== excludeId)
      .map((n) => ({ ...n, children: n.children ? filter(n.children) : [] }))
  return filter(treeData.value)
})

/** 打开对话框：row 存在=编辑，parentId 传入=新增子菜单 */
function openDialog(row?: SysMenu, parentId?: number) {
  isEdit.value = !!row
  if (row) {
    Object.assign(form, {
      id: row.id, parentId: row.parentId, name: row.name, type: row.type ?? 2,
      path: row.path, component: row.component, icon: row.icon,
      permission: row.permission, sort: row.sort ?? 0, status: row.status ?? 1,
    })
  } else {
    Object.assign(form, {
      id: undefined, parentId: parentId, name: '', type: 2,
      path: '', component: '', icon: '', permission: '', sort: 0, status: 1,
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
      await menuApi.update(form as SysMenu)
      ElMessage.success('更新成功')
    } else {
      await menuApi.add(form as SysMenu)
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
async function handleDelete(row: SysMenu) {
  await ElMessageBox.confirm(`确定删除菜单「${row.name}」吗？`, '提示', { type: 'warning' })
  try {
    await menuApi.remove(row.id!)
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
.toolbar { margin-bottom: 16px; }
</style>
