import "./Projectdialog.css";
//MUI
import ClearIcon from '@mui/icons-material/Clear';
import InfoIcon from '@mui/icons-material/Info';
import ApartmentIcon from '@mui/icons-material/Apartment';
import WidgetsIcon from '@mui/icons-material/Widgets';
import  PersonIcon from '@mui/icons-material/Person';
import TaskIcon from '@mui/icons-material/Task';
//Utils
import {formatMoney} from "../../utils/formatMoney";
//Libraries
import dayjs from "dayjs";
//Hooks
import { useTranslation } from 'react-i18next';
//Components
import Dialogform from "../Dialogform/Dialogform";
import IconBtn from "../IconBtn/IconBtn";

export default function Projectdialog({tasks = [],...props}) {
const {t} = useTranslation();
let status={active:t("نشط"), completed:t("مكتمل"), cancelled:t("ملغي")}
let project_type={restoration:t("ترميم") , construction:t("بناء") , finishing:t("إكساء")};
        return (
        <>
        <Dialogform
        title={"تفاصيل المشروع"} 
        icon={<ApartmentIcon sx={{color:'#f07c1f' , fontSize: "28px"}}/>}
        h="92vh" 
        w="650px"
        closebtn={<IconBtn h="28px" w="28px" name="" clr="#999" bgc="#f5f5f5" onClick={props.onClose} icon={<ClearIcon/>}/>}>
                {/*تفاصيل المشروع*/}
                <div className="project-section">
                        <div className="project-section-title"><InfoIcon sx={{color:'#f07c1f' , fontSize: "20px"}}/>{t("معلومات المشروع")}</div>
                        <div className="project-detail-grid">
                        <div className="project-detail-item"><span className="project-label">{t("رقم المشروع")}:</span><span className="project-value">
                                #{props.id}</span>
                        </div>
                        <div className="project-detail-item"><span className="project-label">{t("اسم المشروع")}:</span><span className="project-value">
                                {props.pr_name}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("نوع المشروع")}:</span><span className="project-value"
                                style={{color:'#F07C1F'}}>{project_type[props.pr_type]}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("حالة المشروع")}:</span><span className="project-value">
                                <span className={`type ${props.status}`}>{status[props.status]}</span></span></div>
                        <div className="project-detail-item"><span className="project-label">{t("نسبة الإنجاز")}:</span><span className="project-value">
                                %{props.progress}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("مدة الإنجاز")}:</span><span className="project-value">
                                {props.execution_duration}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("فترة الكفالة")}:</span><span className="project-value">
                                {props.warranty_period}</span></div>        
                        <div className="project-detail-item"><span className="project-label">{t("تاريخ البدء")}:</span><span className="project-value">
                                {dayjs(props.date).format("YYYY-MM-DD") ===null ? dayjs(props.date).format("YYYY-MM-DD") : t("لايوجد")}</span></div>    
                        <div className="project-detail-item"><span className="project-label">{t("الوصف")}:</span><span className="project-value">
                                {props.description}</span></div>
                        </div>
                </div>
                {/*تفاصيل المستخدم*/}
                <div className="project-section">
                        <div className="project-section-title"><PersonIcon sx={{color:'#f07c1f' , fontSize: "20px"}}/>{t("معلومات صاحب المشروع")}</div>
                        <div className="project-detail-grid">
                        <div className="project-detail-item"><span className="project-label">{t("الاسم الكامل")}:</span><span className="project-value">
                                {props.user_name}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("البريد الالكتروني")}:</span><span className="project-value">
                                {props.user_email}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("رقم الهاتف")}:</span><span className="project-value"
                                style={{color:'#F07C1F'}}>{props.user_phone}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("العنوان")}:</span><span className="project-value">
                                {props.user_address}</span></div>                                     
                        </div>
                </div>
                {/*تفاصبل المهندس*/}
                <div className="project-section">
                        <div className="project-section-title"><PersonIcon sx={{color:'#f07c1f' , fontSize: "20px"}}/>{t("معلومات المهندس")}</div>
                        <div className="project-detail-grid">
                        <div className="project-detail-item"><span className="project-label">{t("الاسم الكامل")}:</span><span className="project-value">
                                {props.eng_name}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("البريد الالكتروني")}:</span><span className="project-value">
                                {props.eng_email}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("رقم الهاتف")}:</span><span className="project-value"
                                style={{color:'#F07C1F'}}>{props.eng_phone}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("العنوان")}:</span><span className="project-value">
                                {props.eng_address}</span></div>                                     
                        </div>
                </div>
                {/*تفاصبل المتعهد*/}
                <div className="project-section">
                        <div className="project-section-title"><PersonIcon sx={{color:'#f07c1f' , fontSize: "20px"}}/>{t("معلومات المتعهد")}</div>
                        <div className="project-detail-grid">
                        <div className="project-detail-item"><span className="project-label">{t("الاسم الكامل")}:</span><span className="project-value">
                                {props.cons_name}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("البريد الالكتروني")}:</span><span className="project-value">
                                {props.cons_email}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("رقم الهاتف")}:</span><span className="project-value"
                                style={{color:'#F07C1F'}}>{props.cons_phone}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("العنوان")}:</span><span className="project-value">
                                {props.cons_address}</span></div>                                     
                        </div>
                </div>
                {/*تفاصبل المهام*/}
                <div className="project-section">
                        <div className="project-section-title"><TaskIcon sx={{color:'#f07c1f' , fontSize: "20px"}}/>{t("المهام")}</div>
                        <div className="tasks-list">
                        
                        {tasks.map((task) => (
                        <div className="task-card"  key={task.id}>
                       
                        <div className="task-info">
                                <span>{task.title}</span>
                                <p>{task.description}</p>
                                <div className="task-status">
                                {task.is_completed ? "مكتملة": "قيد التنفيذ"}
                                </div>
                        </div>

                        <div>
                        <div className="task-progress">
                                <div className="progress-bar"><div className="progress-fill" style={{width:`${task.percentage}%`}} /></div>
                                <span>{task.percentage}%</span>
                        </div>
                        </div>
                     
                        </div>
                        ))}
                        
                </div>
                </div>                
                {/*تفاصيل التكلفة*/}
                <div className="project-section">
                        <div className="project-section-title"><WidgetsIcon sx={{color:'#f07c1f' , fontSize: "20px"}}/>{t("التكاليف")}</div>
                        <div className="project-detail-grid">
                        <div className="project-detail-item"><span className="project-label">{t("تكلفة المواد")}:</span><span className="project-value">
                                ${formatMoney(props.materials_cost)}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("تكلفة العمالة")}:</span><span className="project-value"> 
                                ${formatMoney(props.labor_cost)}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("المربح")}:</span><span className="project-value"> 
                                ${formatMoney(props.profit)}</span></div>
                        <div className="project-detail-item"><span className="project-label">{t("التكلفة الكلية")}:</span><span className="project-value"> 
                                ${formatMoney(props.total_cost)}</span></div>        
                        </div>
                </div>
        </Dialogform>
        </>
        );
        }


        