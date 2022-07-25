# 人人网用户基础组件使用说明：
## 一、获取当前登录用户信息的方法
调用 [DRUAccountManager sharedInstance].currentUser，即可获取当前登录的用户信息  

DRUUser *user =  [DRUAccountManager sharedInstance].currentUser;

DRUUser 中包含两个模型， userLoginInfo 和  userInfo;  

userLoginInfo是调用登录接口后返回的数据，包含 key 信息;  

userInfo是登录成功后，调用获取用户信息接口获取的数据;  

请根据需要自行获取相应数据
