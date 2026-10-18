import { common, Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { AbilityEventLog } from '../common/AbilityEventLog';

@Entry
@Component
struct Index {
  @State isStarting: boolean = false;
  @State errorMessage: string = '';

  private async openAbilityB(): Promise<void> {
    if (this.isStarting) {
      return;
    }
    this.isStarting = true;
    this.errorMessage = '';
    try {
      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      const want: Want = {
        bundleName: context.abilityInfo.bundleName,
        moduleName: 'entry',
        abilityName: 'AbilityB'
      };
      AbilityEventLog.record('操作', 'A → B：调用 startAbility');
      await context.startAbility(want);
      AbilityEventLog.record('操作', 'startAbility(B) 调用成功');
    } catch (err) {
      const error = err as BusinessError;
      this.errorMessage = `跳转失败（${error.code}）：${error.message}`;
      AbilityEventLog.record('操作', this.errorMessage, true);
    } finally {
      this.isStarting = false;
    }
  }

  build() {
    Column({ space: 16 }) {
      Text('Ability A')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182431')
        .width('100%')
      Text('点击下方按钮打开 Ability B。')
        .fontSize(15)
        .fontColor('#5C6675')
        .width('100%')
      Button(this.isStarting ? '正在打开…' : '跳转到 Ability B')
        .id('openAbilityB')
        .width('100%')
        .height(48)
        .enabled(!this.isStarting)
        .onClick(() => this.openAbilityB())
      if (this.errorMessage.length > 0) {
        Text(this.errorMessage)
          .fontSize(14)
          .fontColor('#B3261E')
          .width('100%')
      }
    }
    .height('100%')
    .width('100%')
    .padding(20)
    .backgroundColor('#F5F7FA')
    .alignItems(HorizontalAlign.Start)
  }
}
