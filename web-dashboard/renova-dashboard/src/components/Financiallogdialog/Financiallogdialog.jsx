import "./Financiallogdialog.css";
//MUI
import ReceiptIcon from '@mui/icons-material/Receipt';
import ClearIcon from '@mui/icons-material/Clear';
import InfoIcon from '@mui/icons-material/Info';
import PeopleAltIcon from '@mui/icons-material/PeopleAlt';
import CommentIcon from '@mui/icons-material/Comment';
//Utils
import {formatMoney} from "../../utils/formatMoney";
//Libraries
import dayjs from "dayjs";
//Hooks
import { useTranslation } from 'react-i18next';
export default function Financiallogdialog({onClose,log_id,payment_id,log_type,amount,log_date,from_user,to_user,description}) {
     const {t} = useTranslation();
     let type = {first_payment:t("الدفعة الأولى") , second_payment:t("الدفعة الثانية") , final_payment:t("الدفعة الأخيرة"),release:t("محولة")}
    return (
    <>
        <div className="log-dialog-overlay" >
        <div className="log-dialog-box" >

            <div className="log-dialog-header">
                <div className="log-title">
                    <ReceiptIcon sx={{color:'#f07c1f' , fontSize: "28px"}}/>
                    <h3>{t("تفاصيل العملية المالية")}</h3>
                </div>
                <div className="log-close-btn">
                    <ClearIcon onClick={onClose}/>
                </div>
            </div>
            <div className="log-dialog-body">
                <div className="log-section">
                    <div className="log-section-title"><InfoIcon sx={{color:'#f07c1f' , fontSize: "18px"}}/>{t("معلومات العملية")}</div>
                    <div className="log-detail-grid">
                        <div className="log-detail-item"><span className="log-label">{t("رقم السجل")}:</span><span className="log-value">#{log_id}</span></div>
                        <div className="log-detail-item"><span className="log-label">{t("رقم الدفعة")}:</span><span className="log-value">#{payment_id}</span></div>
                        <div className="log-detail-item"><span className="log-label">{t("نوع العملية")}:</span><span className="log-value"><span className={`log-action-badge  ${log_type}`}>{type[log_type]}</span></span></div>
                        <div className="log-detail-item"><span className="log-label">{t("المبلغ")}:</span><span className="log-value-highlight">${formatMoney(amount)}</span></div>
                        <div className="log-detail-item"><span className="log-label">{t("التاريخ")}:</span><span className="log-value">{dayjs(log_date).format('DD MMMM YYYY || hh:mm:ss')}</span></div>
                    </div>
                </div>

      
                <div className="log-section">
                    <div className="log-section-title"><PeopleAltIcon sx={{color:'#f07c1f' , fontSize: "18px"}}/>{t("الأطراف")}</div>
                    <div className="log-detail-grid">
                        <div className="log-detail-item">
                            <span className="log-label">{t("من")}:</span>
                            <span className="log-value">
                                {from_user}
                            </span>
                        </div>
                        <div className="log-detail-item">
                            <span className="log-label">{t("إلى")}:</span>
                            <span className="log-value">
                               {to_user}
                            </span>
                        </div>
                    </div>
                </div>

    
                <div className="log-section">
                    <div className="log-section-title"><CommentIcon sx={{color:'#f07c1f' , fontSize: "18px"}}/>{t("الوصف")}</div>
                    <div style={{ background: '#f8f9fc', borderRadius: '10px', padding: '12px 16px', color: '#0f1f2f', fontSize: '14px', lineHeight: '1.7' }}>
                       {description}
                    </div>
                </div>

            </div>

        </div>
    </div>
    </>)
}