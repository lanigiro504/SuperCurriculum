import FormExtensionAbility from '@ohos.app.form.FormExtensionAbility';
import formBindingData from '@ohos.app.form.formBindingData';
import formProvider from '@ohos.app.form.formProvider';
import { hilog } from '@kit.PerformanceAnalysisKit';
import Want from '@ohos.app.ability.Want';

// 添加FormData相关接口定义
interface FormCourseData {
  id: string;
  name: string;
  classroom: string;
  timeSlot: number;
  duration: number;
  color: string;
}

interface FormData {
  courses: FormCourseData[];
}

const DOMAIN = 0x0000;
const TAG = 'CourseWidgetCard';

export default class CourseWidgetCard extends FormExtensionAbility {
  onAddForm(want: Want): formBindingData.FormBindingData {
    // 卡片创建时触发
    let formId = want.entities ? want.entities[0] : '';
    let formName = want.action || '';
    let tempCard = formBindingData.createFormBindingData({ "courses": [] });

    hilog.info(DOMAIN, TAG, `Form added: ${formId}, ${formName}`);

    // 获取今日课程并更新卡片
    this.updateCard(formId);

    return tempCard;
  }

  onUpdateForm(formId: string): void {
    // 卡片更新时触发
    hilog.info(DOMAIN, TAG, `Form update requested: ${formId}`);
    this.updateCard(formId);
  }

  onRemoveForm(formId: string): void {
    // 卡片删除时触发
    hilog.info(DOMAIN, TAG, `Form removed: ${formId}`);
  }

  onFormEvent(formId: string, message: string): void {
    // 处理卡片事件
    hilog.info(DOMAIN, TAG, `Form event received: ${formId}, message: ${message}`);
  }

  updateCard(formId: string): void {
    try {
      // 模拟课程数据，因为卡片中不能使用复杂的异步服务调用
      const mockCourses: FormCourseData[] = [
        {
          id: "1",
          name: "数学",
          classroom: "A101",
          timeSlot: 1,
          duration: 2,
          color: "#FF6B6B"
        },
        {
          id: "2", 
          name: "英语",
          classroom: "B202",
          timeSlot: 3,
          duration: 1,
          color: "#4ECDC4"
        }
      ];

      // 创建卡片数据
      const formData: FormData = {
        courses: mockCourses
      };

      // 更新卡片
      const cardData = formBindingData.createFormBindingData(formData);
      formProvider.updateForm(formId, cardData);
      hilog.info(DOMAIN, TAG, `Form updated successfully: ${formId}`);
    } catch (error) {
      hilog.error(DOMAIN, TAG, `Failed to update form: ${error instanceof Error ? error.message : String(error)}`);
    }
  }
}
