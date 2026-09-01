<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="表名称" prop="tableName">
        <el-input
          v-model="queryParams.tableName"
          placeholder="请输入表名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="表描述" prop="tableComment">
        <el-input
          v-model="queryParams.tableComment"
          placeholder="请输入表描述"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExportAll"
          v-hasPermi="['system:datadict:export']"
        >导出所有</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          :disabled="multiple"
          @click="handleExportSelected"
          v-hasPermi="['system:datadict:export']"
        >导出选中</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="tableList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="表名称" align="center" prop="tableName" :show-overflow-tooltip="true" />
      <el-table-column label="表描述" align="center" prop="tableComment" :show-overflow-tooltip="true" />
      <el-table-column label="建表时间" align="center" prop="createTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="修改时间" align="center" prop="updateTime" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.updateTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-view"
            @click="handleDetail(scope.row)"
            v-hasPermi="['system:datadict:query']"
          >详情</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
  </div>
</template>

<script>
import { listTable } from "@/api/system/datadict"

export default {
  name: "Datadict",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 表列表数据
      tableList: [],
      // 选中数组
      selectedTableNames: [],
      // 非多个禁用
      multiple: true,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        tableName: undefined,
        tableComment: undefined
      }
    }
  },
  created() {
    this.getList()
  },
  methods: {
    /** 查询数据库表列表 */
    getList() {
      this.loading = true
      listTable(this.queryParams).then(response => {
        this.tableList = response.rows
        this.total = response.total
        this.loading = false
      })
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1
      this.getList()
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm")
      this.handleQuery()
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.selectedTableNames = selection.map(item => item.tableName)
      this.multiple = !selection.length
    },
    /** 表结构详情按钮操作 */
    handleDetail(row) {
      this.$tab.openPage("表结构详情", '/system/datadict-detail/index/' + row.tableName)
    },
    /** 导出所有按钮操作（按搜索条件导出全部匹配表的字段明细） */
    handleExportAll() {
      this.download('system/datadict/table/export', {
        ...this.queryParams
      }, `datadict_${new Date().getTime()}.xlsx`)
    },
    /** 导出选中按钮操作（仅导出勾选表的字段明细） */
    handleExportSelected() {
      this.download('system/datadict/table/export', {
        tableNames: this.selectedTableNames.join(',')
      }, `datadict_${new Date().getTime()}.xlsx`)
    }
  }
}
</script>
