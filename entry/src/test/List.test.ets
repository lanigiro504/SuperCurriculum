import localUnitTest from './LocalUnit.test';
import courseServiceTest from './CourseService.test';

export default function testsuite() {
  localUnitTest();
  courseServiceTest();
}