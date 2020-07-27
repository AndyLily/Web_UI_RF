*** Settings ***
Library           SeleniumLibrary
Library           Collections

*** Test Cases ***
test1
    #用谷歌浏览器打开erp登录页面
    open browser    http://erp.lemfix.com/login.html    gc
    #获取页面标题，验证是否和预期一致
    ${title}    get title
    should be equal    ${title}    柠檬ERP
    #获取页面版本号，验证是否和预期一致
    ${version}    get text    xpath=/html/body/div/div/div[1]/a/small
    run keyword if    '${version}'=='V1.3'    log    ok
    ...    ELSE    log    No
    #正常登录验证
    click element    id=username    #使用ID/name定位元素(当ID/name唯一时）
    input text    id=username    test123
    click element    id=password
    input password    id=password    123456
    click element    xpath=//*[@id="btnSubmit"]
    wait until element is visible    xpath=/html/body/div[1]/aside/div/section/div[1]/div[2]/p    8
    ${username}    get text    xpath=/html/body/div[1]/aside/div/section/div[1]/div[2]/p
    should be equal    ${username}    测试用户
    #查看左侧用户菜单是否和预期一致
    ${tal_relname}    create list    零售管理    采购管理    销售管理    仓库管理    财务管理    报表查询    商品管理    基本资料
    ${tal_exname}    create list
    ${tal_exnum}    get element count    xpath=//*[@id="leftMenu"]/ul/li/a
    FOR    ${i}    IN RANGE    ${tal_exnum}
        ${tal_name}    get text    xpath=//*[@id="leftMenu"]/ul/li[${i}+1]/a
        append to list    ${tal_exname}    ${tal_name}
    END
    should be equal    ${tal_relname}    ${tal_exname}
    #点击左侧菜单能正常打开 --零售出库
    click element    xpath=//*[@id="leftMenu"]/ul/li[1]/ul/li[1]/a
    ${id}    get element attribute    xpath=//*[@id="leftMenu"]/ul/li[1]/ul/li[1]/a    data-tab-id
    ${iframe-id}    catenate    SEPARATOR=    ${id}    -frame    #获取frame的id
    # ${iframe-id}    set variable    ${id}-frame
    select frame    ${iframe-id}    #切换子页面
    ${sub-title}    get text    xpath=/html/body/div[1]/div[1]/div[1]
    should be equal    ${sub-title}    零售出库列表
    #验证空搜索时，显示条目和刚进入时一样
    ${list_bfnum}    get element count    xpath=//*[@id="tablePanel"]/div/div/div[2]/div[2]/div[2]/table/tbody/tr
    click element    searchBtn    #因为默认搜索输入框里为空，所以直接点击搜索按钮即可
    ${list_afnum}    get element count    xpath=//*[@id="tablePanel"]/div/div/div[2]/div[2]/div[2]/table/tbody/tr
    should be equal    ${list_bfnum}    ${list_afnum}
    #验证搜索单据编号：314，显示结果正确
    ${search-num}    set variable    314
    click element    searchNumber
    input text    searchNumber    ${search-num}
    click element    searchBtn
    wait until element is visible    xpath=//*[@id="tablePanel"]/div/div/div[2]/div[2]/div[2]/table/tbody/tr    8
    ${list_num1}    get element count    xpath=//*[@id="tablePanel"]/div/div/div[2]/div[2]/div[2]/table/tbody/tr
    ${num2}    get text    xpath=//*[@id="tablePanel"]/div/div/div[2]/div[2]/div[2]/table/tbody/tr[1]/td[4]/div
    FOR    ${i}    IN RANGE    ${list_num1}
        ${num}    get text    xpath=//*[@id="tablePanel"]/div/div/div[2]/div[2]/div[2]/table/tbody/tr[${i}+1]/td[4]/div
        should match regexp    ${num}    ${search-num}    #正则匹配编号
    END
    #关闭浏览器
    close browser
