<template>
  <div class="app-container">
    <el-card shadow="never" class="mb10">
      <el-row :gutter="10" type="flex" align="middle">
        <el-col :span="8">
          <span class="table-title">{{ tableInfo.tableName || '--' }}</span>
          <span class="table-comment" v-if="tableInfo.tableComment">（{{ tableInfo.tableComment }}）</span>
        </el-col>
        <el-col :span="12" class="table-meta">
          <span>建表时间：{{ parseTime(tableInfo.createTime) || '--' }}</span>
          <span>修改时间：{{ parseTime(tableInfo.updateTime) || '--' }}</span>
        </el-col>
        <el-col :span="4" style="text-align: right">
          <el-button
            type="warning"
            plain
            icon="el-icon-close"
            size="mini"
            @click="handleClose"
          >关闭</el-button>
        </el-col>
      </el-row>
    </el-card>

    <el-tabs v-model="activeTab">
      <!-- 字段明细 -->
      <el-tab-pane label="字段明细" name="column">
        <el-table v-loading="loading" :data="columnList">
          <el-table-column label="字段名称" align="left" prop="columnName" :show-overflow-tooltip="true" />
          <el-table-column label="字段描述" align="left" prop="columnComment" :show-overflow-tooltip="true" />
          <el-table-column label="数据类型" align="center" prop="dataType" width="100" />
          <el-table-column label="长度" align="center" prop="dataLength" width="80">
            <template slot-scope="scope">
              <span>{{ scope.row.dataLength === -1 ? 'MAX' : scope.row.dataLength }}</span>
            </template>
          </el-table-column>
          <el-table-column label="精度" align="center" prop="dataPrecision" width="80" />
          <el-table-column label="小数位" align="center" prop="dataScale" width="80" />
          <el-table-column label="主键" align="center" prop="isPk" width="70">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.isPk === 'Y'" type="success" size="mini">是</el-tag>
              <span v-else>否</span>
            </template>
          </el-table-column>
          <el-table-column label="自增" align="center" prop="isIncrement" width="70">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.isIncrement === 'Y'" type="success" size="mini">是</el-tag>
              <span v-else>否</span>
            </template>
          </el-table-column>
          <el-table-column label="允许空" align="center" prop="isNullable" width="70">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.isNullable === 'N'" type="danger" size="mini">否</el-tag>
              <span v-else>是</span>
            </template>
          </el-table-column>
          <el-table-column label="默认值" align="center" prop="columnDefault" :show-overflow-tooltip="true" />
        </el-table>
      </el-tab-pane>

      <!-- 外键 -->
      <el-tab-pane :label="'外键' + (foreignKeyList.length ? '(' + foreignKeyList.length + ')' : '')" name="foreignKey">
        <el-table :data="foreignKeyList">
          <el-table-column label="外键名称" align="left" prop="fkName" :show-overflow-tooltip="true" />
          <el-table-column label="当前表字段" align="center" prop="columnName" :show-overflow-tooltip="true" />
          <el-table-column label="引用表" align="center" prop="refTableName" :show-overflow-tooltip="true" />
          <el-table-column label="引用字段" align="center" prop="refColumnName" :show-overflow-tooltip="true" />
        </el-table>
      </el-tab-pane>

      <!-- 索引 -->
      <el-tab-pane :label="'索引' + (indexList.length ? '(' + indexList.length + ')' : '')" name="index">
        <el-table :data="indexList">
          <el-table-column label="索引名称" align="left" prop="indexName" :show-overflow-tooltip="true" />
          <el-table-column label="索引类型" align="center" prop="indexType" width="140" />
          <el-table-column label="主键" align="center" prop="isPk" width="70">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.isPk === 'Y'" type="success" size="mini">是</el-tag>
              <span v-else>否</span>
            </template>
          </el-table-column>
          <el-table-column label="唯一" align="center" prop="isUnique" width="70">
            <template slot-scope="scope">
              <el-tag v-if="scope.row.isUnique === 'Y'" type="warning" size="mini">是</el-tag>
              <span v-else>否</span>
            </template>
          </el-table-column>
          <el-table-column label="包含字段" align="left" prop="indexColumns" :show-overflow-tooltip="true" />
        </el-table>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import { getTable } from "@/api/system/datadict"

export default {
  name: "DataDictDetail",
  data() {
    return {
      // 遮罩层
      loading: true,
      // 激活页签
      activeTab: "column",
      // 表基本信息
      tableInfo: {},
      // 字段明细列表
      columnList: [],
      // 外键列表
      foreignKeyList: [],
      // 索引列表
      indexList: []
    }
  },
  created() {
    const tableName = this.$route.params && this.$route.params.tableName
    this.getTable(tableName)
  },
  methods: {
    /** 查询表结构详情 */
    getTable(tableName) {
      this.loading = true
      getTable(tableName).then(response => {
        this.tableInfo = response.data.info || {}
        this.columnList = response.data.columns || []
        this.foreignKeyList = response.data.foreignKeys || []
        this.indexList = response.data.indexes || []
        this.loading = false
      })
    },
    /** 关闭按钮操作 */
    handleClose() {
      const obj = { path: "/system/datadict" }
      this.$tab.closeOpenPage(obj)
    }
  }
}
</script>

<style scoped>
.mb10 {
  margin-bottom: 10px;
}
.table-title {
  font-size: 16px;
  font-weight: bold;
}
.table-comment {
  color: #909399;
}
.table-meta span {
  color: #909399;
  margin-right: 20px;
}
</style>
