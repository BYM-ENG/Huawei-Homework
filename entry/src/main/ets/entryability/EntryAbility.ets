import { AbilityConstant, ConfigurationConstant, UIAbility, Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { AbilityEventLog } from '../common/AbilityEventLog';


export default class EntryAbility extends UIAbility {
  private observedWindowStage: window.WindowStage | undefined = undefined;
  private readonly stageEventCallback = (event: window.WindowStageEventType): void => {
    AbilityEventLog.record('A.WindowStage', `${this.getStageEventName(event)} (${event})`);
  };

  private getStageEventName(event: window.WindowStageEventType): string {
    switch (event) {
      case window.WindowStageEventType.SHOWN:
        return 'SHOWN：窗口进入前台';
      case window.WindowStageEventType.ACTIVE:
        return 'ACTIVE：窗口获得焦点';
      case window.WindowStageEventType.INACTIVE:
        return 'INACTIVE：窗口失去焦点';
      case window.WindowStageEventType.HIDDEN:
        return 'HIDDEN：窗口进入后台';
      case window.WindowStageEventType.RESUMED:
        return 'RESUMED：前台可交互';
      case window.WindowStageEventType.PAUSED:
        return 'PAUSED：前台不可交互';
      default:
        return 'UNKNOWN：未知事件';
    }
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    AbilityEventLog.record('A.UIAbility', 'onCreate');
  }

  onDestroy(): void {
    AbilityEventLog.record('A.UIAbility', 'onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    AbilityEventLog.record('A.UIAbility', 'onWindowStageCreate');

    // 在加载页面前注册监听，避免遗漏首次显示的 WindowStage 事件。
    try {
      windowStage.on('windowStageEvent', this.stageEventCallback);
      this.observedWindowStage = windowStage;
      AbilityEventLog.record('A.Listener', '已注册 windowStageEvent');
    } catch (err) {
      AbilityEventLog.record('A.Listener', `注册失败：${JSON.stringify(err)}`, true);
    }

    windowStage.loadContent('pages/Index', (err) => {
      if (err.code) {
        AbilityEventLog.record('A.Page', `页面加载失败：${JSON.stringify(err)}`, true);
        return;
      }
      AbilityEventLog.record('A.Page', 'pages/Index 加载成功');
    });

    try {
      this.context.getApplicationContext().setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_NOT_SET);
    } catch (err) {
      AbilityEventLog.record('A.UIAbility', `设置颜色模式失败：${JSON.stringify(err)}`, true);
    }
  }

  onWindowStageDestroy(): void {
    AbilityEventLog.record('A.UIAbility', 'onWindowStageDestroy');
    // A 退到后台时仍保留监听，只在 WindowStage 销毁时注销。
    if (this.observedWindowStage) {
      try {
        this.observedWindowStage.off('windowStageEvent', this.stageEventCallback);
      } catch (err) {
        AbilityEventLog.record('A.Listener', `注销失败：${JSON.stringify(err)}`, true);
      }
      this.observedWindowStage = undefined;
    }
  }

  onForeground(): void {
    AbilityEventLog.record('A.UIAbility', 'onForeground');
  }

  onBackground(): void {
    AbilityEventLog.record('A.UIAbility', 'onBackground');
  }
}
