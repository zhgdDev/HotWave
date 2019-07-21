
热点图组件

背景:由于马甲需求井喷,急需提效.主要是为了过审,界面都比较类化,事件比较固定.现提出热点图方案.

  一 关注点:
  
    1 响应事件
    2 资源配置
    3 分割组件
    
  二 方案设计思路:
  
    1 界面可分割成一条一条的组件
    2 一个组件可以是一个图片也可以是一个原生组件
    3 可捕捉事件区域进行交互
    4 数据源分加载显示的showSource和更新资源updateSource
    5 更新分直接更新和联动更新两类
    
    
三 风险评估:

    1 由于是配置的图,可能审核有所困难
    2 需要和UI、java沟通
   
四 后期扩展:
    
    1 后期可后台配置
    2 代码混淆

    
   
   
    