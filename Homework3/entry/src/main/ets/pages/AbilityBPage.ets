import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { AbilityEventLog } from '../common/AbilityEventLog';

@Entry
@Component
struct AbilityBPage {
  @State isReturning: boolean = false;
  @State errorMessage: string = '';

  private async returnToAbilityA(): Promise<void> {
    if (this.isReturning) {
      return;
    }
    this.isReturning = true;
    this.errorMessage = '';
    try {
      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      AbilityEventLog.record('操作', 'B → A：调用 terminateSelf 关闭 B');
      await context.terminateSelf();
    } catch (err) {
      const error = err as BusinessError;
      this.errorMessage = `返回失败（${error.code}）：${error.message}`;
      AbilityEventLog.record('操作', this.errorMessage, true);
      this.isReturning = false;
    }
  }

  build() {
    Column({ space: 16 }) {
      Text('Ability B')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor('#182431')
        .width('100%')
      Text('已进入 Ability B，可返回 Ability A。')
        .fontSize(15)
        .fontColor('#5C6675')
        .width('100%')
      Button(this.isReturning ? '正在返回…' : '返回 Ability A')
        .id('returnToAbilityA')
        .width('100%')
        .height(48)
        .enabled(!this.isReturning)
        .onClick(() => this.returnToAbilityA())
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
