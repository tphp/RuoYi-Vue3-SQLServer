import request from '@/utils/request'

// 查询数据库表列表
export function listTable(query) {
  return request({
    url: '/system/datadict/table/list',
    method: 'get',
    params: query
  })
}

// 查询表结构详情（表信息 + 字段 + 外键 + 索引）
export function getTable(tableName) {
  return request({
    url: '/system/datadict/table/' + tableName,
    method: 'get'
  })
}

// 查询指定表的字段明细列表
export function listColumn(tableName) {
  return request({
    url: '/system/datadict/column/list',
    method: 'get',
    params: { tableName }
  })
}
