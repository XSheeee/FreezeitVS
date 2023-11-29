// Freezeit 冻它模块  By JARK006

#include "freezeit.hpp"
#include "settings.hpp"
#include "managedApp.hpp"
#include "systemTools.hpp"
#include "doze.hpp"
#include "freezer.hpp"
#include "server.hpp"

int main(int argc, char **argv) {
    //先获取模块当前目录，Init()开启守护线程后, 工作目录将切换到根目录 "/"
    char fullPath[1024] = {};
    auto pathPtr = realpath(argv[0], fullPath); 

    Utils::Init();

    Freezeit freezeit(argc, string(pathPtr));
    Settings settings(freezeit);
    SystemTools systemTools(freezeit, settings);
    ManagedApp managedApp(freezeit, settings);
    Doze doze(freezeit, settings, managedApp, systemTools);
    Freezer freezer(freezeit, settings, managedApp, systemTools, doze);
    Server server(freezeit, settings, managedApp, systemTools, doze, freezer);

    //sleep(3600 * 24 * 365);//放年假
    //什么年代了还在放传统年假
    //还有两年就是闰年了，提前放一下吧
    sleep(3600 * 24 * 366);
    return 0;
}

/*
TODO

1. 识别状态栏播放控件为前台 参考开源APP listen1 lxmusic
2. 进程冻结状态整合
3. 一些应用解冻后无法进入下一个activity
4. QQ解冻无网络

*/

