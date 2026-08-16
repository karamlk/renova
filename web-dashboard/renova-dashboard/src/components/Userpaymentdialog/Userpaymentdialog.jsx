import "./Userpaymentdialog.css";
//MUI
import ReceiptIcon from '@mui/icons-material/Receipt';
import ClearIcon from '@mui/icons-material/Clear';
import InfoIcon from '@mui/icons-material/Info';
import ApartmentIcon from '@mui/icons-material/Apartment';
import PeopleAltIcon from '@mui/icons-material/PeopleAlt';
import WidgetsIcon from '@mui/icons-material/Widgets';
//Utils
import {formatMoney} from "../../utils/formatMoney";
//Libraries
import dayjs from "dayjs";
//Hooks
import { useTranslation } from 'react-i18next';
//Components
import Dialogform from "../Dialogform/Dialogform";

export default function Userpaymentdialog({onClose,id,p_type,amount,released_amount,p_status,date,
    pr_name,pr_type,pr_total_cost,pr_status,warranty_period,execution_duration,
    user_n,cons_n,eng_n,
    materials_cost,labor_cost,profit}) {
        const {t} = useTranslation();
        let type = {first_payment:t("الدفعة الأولى") , second_payment:t("الدفعة الثانية") , final_payment:t("الدفعة الأخيرة")}
        let status = {paid:t("مدفوعة"),pending:t("بانتظار الدفع"),released:t("محولة")}
        let project_type={restoration:t("ترميم") , construction:t("بناء") , finishing:t("إكساء")};
    return (
    <>
     <Dialogform
        title={"تفاصيل الدفعة"} 
        icon={<ReceiptIcon sx={{color:'#f07c1f' , fontSize: "28px"}}/>}
        h="92vh" 
        w="650px"
        closebtn={<div className="userpayment-close-btn" onClick={onClose}><ClearIcon/></div>}
        >
                <div className="userpayment-section">
                    <div className="userpayment-section-title"><InfoIcon sx={{color:'#f07c1f' , fontSize: "20px"}}/>{t("معلومات الدفعة")}</div>
                    <div className="userpayment-detail-grid">
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("رقم الدفعة")}:</span><span className="userpayment-value">
                            #{id}</span>
                        </div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("نوع الدفعة")}:</span><span className="userpayment-value">
                            {type[p_type]}</span></div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("المبلغ")}:</span><span className="userpayment-value"
                                style={{color:'#4CAF50'}}>${formatMoney(amount)}</span></div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("المحول منها")}:</span><span className="userpayment-value"
                                style={{color:'#2196F3'}}>${formatMoney(released_amount)}</span></div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("الحالة")}:</span><span className="userpayment-value">
                            <span className={`userpayment-status-badge ${p_status}`}>{status[p_status]}</span></span></div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("تاريخ الدفع")}:</span><span className="userpayment-value">
                            {dayjs(date).format("YYYY-MM-DD")}</span></div>
                    </div>
                </div>

    
                <div className="userpayment-section">
                    <div className="userpayment-section-title"><ApartmentIcon sx={{color:'#f07c1f' , fontSize: "20px"}}/>{t("معلومات المشروع")}</div>
                    <div className="userpayment-detail-grid">
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("اسم المشروع")}:</span><span className="userpayment-value">
                                {pr_name}</span></div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("نوع المشروع")}:</span><span className="userpayment-value">
                                {project_type[pr_type]}</span></div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("التكلفة الإجمالية")}:</span><span className="userpayment-value"
                                style={{color:'#F07C1F'}}>${formatMoney(pr_total_cost)}</span></div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("حالة المشروع")}:</span><span className="userpayment-value">
                                {pr_status}</span></div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("كفالة المشروع")}:</span><span className="userpayment-value">
                                {warranty_period}</span></div>   
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("مدة الإنجاز")}:</span><span className="userpayment-value">
                                {execution_duration}</span></div>                                     
                        </div>
                </div>
              

                <div className="userpayment-section">
                    <div className="userpayment-section-title"><PeopleAltIcon sx={{color:'#f07c1f' , fontSize: "20px"}}/>{t("الأطراف")}</div>
                    <div className="userpayment-detail-grid">
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("المستخدم")}:</span><span className="userpayment-value">
                                {user_n}</span></div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("المتعهد")}:</span><span className="userpayment-value"> 
                                {cons_n}</span></div>
                        <div className="userpayment-detail-item"><span className="userpayment-label">{t("المهندس")}:</span><span className="userpayment-value"> 
                                {eng_n}</span></div>
                    </div>
                </div>

       
                <div className="userpayment-section">
                    <div className="userpayment-section-title"><WidgetsIcon sx={{color:'#f07c1f' , fontSize: "20px"}}/>{t("التكاليف")}</div>
                    <div className="userpayment-detail-materials">
                        <div className="userpayment-material-item">
                            <div className="userpayment-name">{t("المواد")}</div>
                            <div className="userpayment-price">${formatMoney(materials_cost)}</div>
                        </div>
                        <div className="userpayment-material-item">
                            <div className="userpayment-name">{t("العمالة")}</div>
                            <div className="userpayment-price">${formatMoney(labor_cost)}</div>
                        </div>
                        <div className="userpayment-material-item">
                            <div className="userpayment-name">{t("الربح")}</div>
                            <div className="userpayment-price">${formatMoney(profit)}</div>
                        </div>
                    </div>
                </div>
        </Dialogform>
        </>
    );
}