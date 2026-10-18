import { UIAbility } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';
import { AbilityEventLog } from '../common/AbilityEventLog';

export default class AbilityB extends UIAbility {
  onWindowStageCreate(windowStage: window.WindowStage): void {
    windowStage.loadContent('pages/AbilityBPage', (err) => {
      if (err.code) {
        AbilityEventLog.record('B.Page', `页面加载失败：${JSON.stringify(err)}`, true);
      }
    });
  }
}
