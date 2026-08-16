import "./Notificationlist.css";
//MUI
import NotificationsIcon from '@mui/icons-material/Notifications';
import DoneAllIcon from '@mui/icons-material/DoneAll';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import CheckIcon from '@mui/icons-material/Check';
import AddIcon from '@mui/icons-material/Add';
//Components
import Button from "../Button/Button";
export default function Notificationlist({message ,onclick}){
            let notifications = [{
            id: 1,
            title: 'تم قبول طلبك',
            description: 'تم قبول طلب إعادة الإعمار الخاص بك. يمكنك الآن متابعة المشروع.',
            time: 'منذ 5 دقائق',
            read: false,
            avatar: 'أ',
            color: 'orange',
            isread: 0
        }, {
            id: 2,
            title: 'دفعة جديدة',
            description: 'تم إضافة دفعة جديدة لمشروع مجمع الزيتون بقيمة 33,780 $',
            time: 'منذ ساعة',
            read: false,
            avatar: 'م',
            color: 'blue',
            isread: 1
        }, {
            id: 3,
            title: 'تحديث المشروع',
            description: 'تم تحديث حالة مشروع مدرسة الشروق إلى "قيد التنفيذ"',
            time: 'منذ 3 ساعات',
            read: false,
            avatar: 'س',
            color: 'green',
            isread: 0
        }, {
            id: 4,
            title: 'شكوى جديدة',
            description: 'تم استلام شكوى جديدة من المستخدم أحمد المحمد.',
            time: 'منذ 5 ساعات',
            read: true,
            avatar: 'ن',
            color: 'purple',
            isread: 1
        },{
            id: 2,
            title: 'دفعة جديدة',
            description: 'تم إضافة دفعة جديدة لمشروع مجمع الزيتون بقيمة 33,780 $',
            time: 'منذ ساعة',
            read: false,
            avatar: 'م',
            color: 'blue',
            isread: 1
        }, {
            id: 3,
            title: 'تحديث المشروع',
            description: 'تم تحديث حالة مشروع مدرسة الشروق إلى "قيد التنفيذ"',
            time: 'منذ 3 ساعات',
            read: false,
            avatar: 'س',
            color: 'green',
            isread: 0
        }, {
            id: 4,
            title: 'شكوى جديدة',
            description: 'تم استلام شكوى جديدة من المستخدم أحمد المحمد.',
            time: 'منذ 5 ساعات',
            read: true,
            avatar: 'ن',
            color: 'purple',
            isread: 1
        },{
            id: 2,
            title: 'دفعة جديدة',
            description: 'تم إضافة دفعة جديدة لمشروع مجمع الزيتون بقيمة 33,780 $',
            time: 'منذ ساعة',
            read: false,
            avatar: 'م',
            color: 'blue',
            isread: 1
        }, {
            id: 3,
            title: 'تحديث المشروع',
            description: 'تم تحديث حالة مشروع مدرسة الشروق إلى "قيد التنفيذ"',
            time: 'منذ 3 ساعات',
            read: false,
            avatar: 'س',
            color: 'green',
            isread: 0
        }, {
            id: 4,
            title: 'شكوى جديدة',
            description: 'تم استلام شكوى جديدة من المستخدم أحمد المحمد.',
            time: 'منذ 5 ساعات',
            read: true,
            avatar: 'ن',
            color: 'purple',
            isread: 1
        }];

    return(
        <div className="notifications-dropdown" >
            <div className="dropdown-header">
                <span className="title">
                    <NotificationsIcon sx={{color : "#f07c1f" , fontSize:"22px"}}/>
                     الإشعارات
                    <span className="badge-count" >{notifications.length}</span>
                </span>
                <Button className="all-read" text="الكل مقروء" icon={<DoneAllIcon sx={{fontSize:"18px"}}/>}/>

            </div>
        <div className="dropdown-body">
            {notifications.map((notification) => (
                <div className="notification-item">
                    <div className="notification-info">
                        <div className="notification-icon"><NotificationsIcon/></div>
                        <div className="content">
                            <div className="title">{notification.title}</div>
                            <div className="desc">{notification.description}</div>
                            <div className="time">
                                <AccessTimeIcon sx={{fontSize:"15px"}}/>
                                 <div className="realtime">{notification.time}</div>
                                 </div>
                        </div>
                    </div>
                    <div className="actions">
                        {notification.isread === 0 ?
                        (<Button className="un-read" text="اعتبره مقروء" icon={<CheckIcon sx={{fontSize:"15px"}}/>}/>):
                        (<Button className="is-read" text="مقروء" />)}
                    </div>
                </div>
            ))}
            <Button className="show-more" text="عرض المزيد" icon={<AddIcon sx={{fontSize:"16px"}}/>}/>
            </div>

    </div>        
    )
}