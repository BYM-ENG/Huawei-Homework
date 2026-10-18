import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN: number = 0x0000;
const TAG: string = 'AbilityAWindowStage';

// 事件只输出到 HiLog，使用统一标签、序号和时间便于排查。
export class AbilityEventLog {
  private static sequence: number = 0;

  static record(source: string, message: string, isError: boolean = false): void {
    const now = new Date();
    const time = `${now.toLocaleTimeString()}.${now.getMilliseconds().toString().padStart(3, '0')}`;
    const line = `#${++AbilityEventLog.sequence} ${time} [${source}] ${message}`;
    if (isError) {
      hilog.error(DOMAIN, TAG, '%{public}s', line);
    } else {
      hilog.info(DOMAIN, TAG, '%{public}s', line);
    }
  }
}
