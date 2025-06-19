import { hilog } from '@kit.PerformanceAnalysisKit';
import { CourseItem } from '../models/CourseModel';
import { notificationManager } from '@kit.NotificationKit';
import { wantAgent } from '@kit.AbilityKit';

const DOMAIN = 0x0000;
const TAG = 'NotificationService';

// 课程时间定义
export interface TimePoint {
  start: string;
  end: string;
}

export class NotificationService {
  // 课程时间配置
  private timePoints: TimePoint[] = [
    { start: '08:00', end: '09:35' },
    { start: '10:05', end: '11:40' },
    { start: '14:00', end: '15:35' },
    { start: '16:05', end: '17:40' },
    { start: '19:00', end: '20:35' }
  ];

  // 为课程安排通知
  async scheduleCourseNotifications(courses: CourseItem[], advanceMinutes: number = 15): Promise<void> {
    try {
      hilog.info(DOMAIN, TAG, 'Scheduling course notifications');
      
      const currentDay = new Date().getDay();
      const now = new Date();
      
      for (const course of courses) {
        // 计算课程开始时间
        const courseDay = course.weekDay === 7 ? 0 : course.weekDay;
        let daysToAdd = (courseDay - currentDay + 7) % 7;
        if (daysToAdd === 0) {
          daysToAdd = 7;
        }
        
        const courseDate = new Date(now);
        courseDate.setDate(courseDate.getDate() + daysToAdd);
        
        // 获取课程时间段
        const timeSlotIndex = course.timeSlot - 1;
        if (timeSlotIndex >= 0 && timeSlotIndex < this.timePoints.length) {
          const timePoint = this.timePoints[timeSlotIndex];
          
          // 解析时间
          const timeParts = timePoint.start.split(':');
          const startHour = parseInt(timeParts[0]);
          const startMinute = parseInt(timeParts[1]);
          
          courseDate.setHours(startHour, startMinute - advanceMinutes, 0, 0);
          
          const timeMillis = courseDate.getTime();
          
          if (timeMillis > now.getTime()) {
            await this.scheduleNotification(
              course.id,
              `${course.name} 开始`,
              `课程：${course.name} ${course.classroom}`,
              course.teacher,
              timeMillis
            );
            
            hilog.info(DOMAIN, TAG, `Scheduled notification for course: ${course.name} at ${courseDate.toString()}`);
          }
        }
      }
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      hilog.error(DOMAIN, TAG, `Failed to schedule notification: ${errorMsg}`);
      throw new Error(errorMsg);
    }
  }

  // 发送单个通知
  private async scheduleNotification(id: string, title: string, text: string, teacher: string, timeMillis: number): Promise<void> {
    try {
      // 创建WantAgent
      const wantAgentInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            bundleName: 'com.example.myapplication',
            abilityName: 'EntryAbility',
            parameters: {
              courseId: id
            }
          }
        ],
        operationType: wantAgent.OperationType.START_ABILITY,
        requestCode: parseInt(id) || 1
      };
      
      const agent = await wantAgent.getWantAgent(wantAgentInfo);
      
      // 创建通知请求
      const notificationRequest: notificationManager.NotificationRequest = {
        id: parseInt(id) || 1,
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal: {
            title: title,
            text: text,
            additionalText: '超级课程表'
          }
        },
        showDeliveryTime: true,
        deliveryTime: timeMillis,
        actionButtons: [
          {
            title: '查看详情',
            wantAgent: agent
          }
        ],
        wantAgent: agent
      };
      
      // 发布通知
      await notificationManager.publish(notificationRequest);
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      hilog.error(DOMAIN, TAG, `Failed to publish notification: ${errorMsg}`);
      throw new Error(errorMsg);
    }
  }
  
  // 取消所有通知
  async cancelAllNotifications(): Promise<void> {
    try {
      await notificationManager.cancelAll();
      hilog.info(DOMAIN, TAG, 'All notifications canceled');
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      hilog.error(DOMAIN, TAG, `Failed to cancel notifications: ${errorMsg}`);
      throw new Error(errorMsg);
    }
  }

  // 发送即时通知（用于测试）
  async sendImmediateNotification(title: string, text: string): Promise<void> {
    try {
      const notificationRequest: notificationManager.NotificationRequest = {
        id: Date.now(),
        content: {
          notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
          normal: {
            title: title,
            text: text,
            additionalText: '超级课程表'
          }
        }
      };
      
      await notificationManager.publish(notificationRequest);
      hilog.info(DOMAIN, TAG, `Immediate notification sent: ${title}`);
    } catch (error) {
      const errorMsg = error instanceof Error ? error.message : String(error);
      hilog.error(DOMAIN, TAG, `Failed to send immediate notification: ${errorMsg}`);
      throw new Error(errorMsg);
    }
  }
}
