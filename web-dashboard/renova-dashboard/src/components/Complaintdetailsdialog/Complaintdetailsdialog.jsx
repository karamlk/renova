import "./Complaintdetailsdialog.css";
//MUI
import DescriptionIcon from '@mui/icons-material/Description';
import ClearIcon from '@mui/icons-material/Clear';
import PersonIcon from '@mui/icons-material/Person';
import PersonOffIcon from '@mui/icons-material/PersonOff';
import ApartmentIcon from '@mui/icons-material/Apartment';
import CollectionsIcon from '@mui/icons-material/Collections';
import GavelIcon from '@mui/icons-material/Gavel';
import InventoryIcon from '@mui/icons-material/Inventory';
import PlaceIcon from '@mui/icons-material/Place';
import Avatar from '@mui/material/Avatar';
//Components
import Imagedialog from "../../components/Imagedialog/Imagedialog";
import Dialogform from "../Dialogform/Dialogform";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState } from "react";
//Libraries
import dayjs from "dayjs";
export default function Complaintdetailsdialog({
    onClose,id,status,type,title,description,date,
    complaint_img,complaint_n,complaint_r,complaint_p,complaint_e,complaint_l,
    complainton_img,complainton_n,complainton_r,complainton_p,complainton_e,complainton_l,complainton_c,
    p_title,p_type,p_location,p_status,
    images,
    admin_note,penalty_percentage,penalty_amount,resolved_at,
    is_archived,archived_at}){
         const {t}=useTranslation();
         const [openimage,setopenimage] = useState(false);
         const [selectedImage, setSelectedImage] = useState("");
         let comp_status={ open:t("مفتوحة"), resolved:t("تمت المعالجة"), dismissed:t("مرفوضة") }
         let user_role = { 2:t("مستخدم"), 3:t("متعهد"), 4:t("مهندس")}
         let comp_type = { no_show:t("عدم الحضور"),general:t("عامة")}
         let project_type={restoration:t("ترميم") , construction:t("بناء") , finishing:t("إكساء")};
         let display_status=status ? status : "auto";
    return(
        <>
        {openimage && (<Imagedialog src={selectedImage} onClose={() => setopenimage(false)}/>)}
         <Dialogform
        title={"تفاصيل الشكوى"} 
        icon={<DescriptionIcon sx={{color: '#f07c1f' , fontSize: 30}} />}
        h="90vh" 
        w="700px"
        closebtn={<div className="complaints-close-btn" onClick={onClose}><ClearIcon/></div>}>
                <div className="complaints-section">
                    <div className="complaints-section-main-title">
                        <div className="complaints-sub-title">
                        <DescriptionIcon sx={{color: '#f07c1f', fontSize: 21}}/>
                       {t("معلومات الشكوى")}
                        </div>
                        <span className={`complaints-badge  ${display_status}`}>
                            <span className={`complaints-status-dot ${display_status}`}></span>
                            <span>{status?comp_status[status]:t("تمت المعالجة تلقائياً")}</span>
                        </span>
                    </div>
                    <div className="complaints-info-grid">
                        <div className="complaints-info-item"><span className="complaints-label">{t("رقم الشكوى")}:</span><span className="complaints-value">#{id}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("الحالة")}:</span><span className="complaints-value"><span className={`complaints-status-dot ${display_status}`}></span>{status?comp_status[status]:t("تمت المعالجة تلقائياً")}<span></span></span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("النوع")}:</span><span className="complaints-value">{comp_type[type]}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("السبب")}:</span><span className="complaints-value">{title}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("الوصف")}:</span><span className="complaints-value">{description}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("تاريخ التقديم")}:</span><span className="complaints-value">{dayjs(date).format("YYYY-MM-DD")}</span></div>
                    </div>
                </div>

            
                <div className="complaints-section">
                    <div className="complaints-section-title"><PersonIcon sx={{color: '#f07c1f', fontSize: 21}}/>{t("مقدم الشكوى")}</div>
                    <div className="complaints-info-grid">
                        <div className="complaints-info-item">
                            <span className="complaints-label">{t("الصورة")}</span>
                            {complaint_img ? <Avatar onClick={(e)=>{
                                e.stopPropagation();
                                setSelectedImage(complaint_img);
                                setopenimage(true)}} alt="img" src={complaint_img} sx={{ width: 55, height: 55}}/>:<Avatar  alt=""  sx={{ width: 55, height: 55 , color: "#f07c1f", backgroundColor: "rgba(240, 124, 31, 0.1)"   }} />}
                        </div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("الاسم")}:</span><span className="complaints-value">{complaint_n}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("الحساب")}:</span><span className="complaints-value">{user_role[complaint_r]}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("الهاتف")}:</span><span className="complaints-value">{complaint_p}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("البريد الالكتروني")}:</span><span className="complaints-value">{complaint_e}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("الموقع")}:</span><span className="complaints-value"><PlaceIcon sx={{color: '#f07c1f' , fontSize: 18}}/>{complaint_l}</span></div>
                    </div>
                </div>

          
                <div className="complaints-section">
                    <div className="complaints-section-title"><PersonOffIcon sx={{color: '#f07c1f', fontSize: 21}}/>{t("المشكي عليه")}</div>
                    <div className="complaints-info-grid">
                        <div className="complaints-info-item">
                            <span className="complaints-label">{t("الصورة")}</span>
                            {complainton_img? <Avatar onClick={(e)=>{
                                e.stopPropagation();
                                setSelectedImage(complainton_img);
                                setopenimage(true)}} alt="img" src={complainton_img} sx={{ width: 55, height: 55}}/>:<Avatar  alt=""  sx={{ width: 55, height: 55 , color: "#f07c1f", backgroundColor: "rgba(240, 124, 31, 0.1)"   }} />}
                        </div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("الاسم")}:</span><span className="complaints-value">{complainton_n}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("نوع الحساب")}:</span><span className="complaints-value">{user_role[complainton_r]}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("الهاتف")}:</span><span className="complaints-value">{complainton_p}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("البريد الالكتروني")}:</span><span className="complaints-value">{complainton_e}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("الموقع")}:</span><span className="complaints-value"><PlaceIcon sx={{color: '#f07c1f' , fontSize: 18}}/>{complainton_l}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("عدد الشكاوى السابقة")}:</span><span className="complaints-value">{complainton_c}</span></div>
                    </div>
                </div>

            
                <div className="complaints-section">
                    <div className="complaints-section-title"><ApartmentIcon sx={{color: '#f07c1f', fontSize: 21}}/>{t("معلومات الطلب")}</div>
                    <div className="complaints-info-grid">
                        <div className="complaints-info-item"><span className="complaints-label">{t("اسم الطلب")}:</span><span className="complaints-value">{p_title}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("نوع الطلب")}:</span><span className="complaints-value">{project_type[p_type]}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("موقع الطلب")}:</span><span className="complaints-value"><PlaceIcon sx={{color: '#f07c1f' , fontSize: 18}}/>{p_location}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("حالة الطلب")}:</span><span className="complaints-value">{t(p_status)}</span></div>
                    </div>
                </div>

                {images?.length === 0 ? (<></>):(
                    <div className="complaints-section">
                    <div className="complaints-section-title"><CollectionsIcon sx={{color: '#f07c1f', fontSize: 21}}/>{t("الصور")}</div>
                    <div className="complaints-images-grid">
                        {images?.map((image) => {
                            return(
                       
                                <div className="complaints-img-thumb" key={image?.id} onClick={(e)=>{
                                e.stopPropagation();
                                setSelectedImage(image?.full_image_url);
                                setopenimage(true)}}>
                                    <img src={image?.full_image_url} alt=""/>
                                </div>
                        )})}
                    </div>
                </div>
                )}
                

                {status === "resolved" && (
                                    <div className="complaints-section">
                    <div className="complaints-section-title"><GavelIcon sx={{color: '#f07c1f', fontSize: 21}}/>{t("نتيجة المعالجة")}</div>
                    <div className="complaints-result-box">
                        <div className="complaints-info-grid">
                            <div className="complaints-info-item"><span className="complaints-label">{t("قرار الإدارة")}:</span><span className="complaints-value" >{comp_status[status]?comp_status[status]:t("تمت المعالجة تلقائياً")}</span></div>
                            <div className="complaints-info-item"><span className="complaints-label">{t("ملاحظات الإدارة")}:</span><span className="complaints-value">{admin_note?admin_note:t("لايوجد ملاحظة")}</span></div>
                            <div className="complaints-info-item"><span className="complaints-label">{t("نسبة العقوبة")}:</span><span className="complaints-value" >{penalty_percentage?penalty_percentage:0}%</span></div>
                            <div className="complaints-info-item"><span className="complaints-label">{t("قيمة العقوبة")}:</span><span className="complaints-value" >${penalty_amount?penalty_amount:0}</span></div>
                            <div className="complaints-info-item"><span className="complaints-label">{t("تاريخ المعالجة")}:</span><span className="complaints-value">{dayjs(resolved_at).format("YYYY-MM-DD")}</span></div>
                        </div>
                    </div>
                </div>
                )}


                <div className="complaints-section">
                    <div className="complaints-section-title"><InventoryIcon sx={{color: '#f07c1f', fontSize: 21}}/>{t("الأرشفة")}</div>
                    <div className="complaints-info-grid">
                        <div className="complaints-info-item"><span className="complaints-label">{t("تمت الأرشفة")}:</span><span className="complaints-value" >{is_archived ? t("تمت الأرشفة") : t("لم تتم الأرشفة")}</span></div>
                        <div className="complaints-info-item"><span className="complaints-label">{t("تاريخ الأرشفة")}:</span><span className="complaints-value">{dayjs(archived_at).format("YYYY-MM-DD")?dayjs(archived_at).format("YYYY-MM-DD"):t("لم تتم الأرشفة")}</span></div>
                    </div>
                </div>

        </Dialogform>   
    </>
    )
}