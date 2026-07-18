import "./Requests.css"
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//MUI Icons
import Avatar from '@mui/material/Avatar';
import ApartmentIcon from '@mui/icons-material/Apartment';
import EmailIcon from '@mui/icons-material/Email';
import LocalPhoneIcon from '@mui/icons-material/LocalPhone';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import CalendarMonthIcon from '@mui/icons-material/CalendarMonth';
import VisibilityIcon from '@mui/icons-material/Visibility';
import CheckIcon from '@mui/icons-material/Check';
import CloseIcon from '@mui/icons-material/Close';
import AccountCircleIcon from '@mui/icons-material/AccountCircle';
import PersonAddIcon from '@mui/icons-material/PersonAdd';
import RefreshIcon from '@mui/icons-material/Refresh';
import AssignmentTurnedInIcon from '@mui/icons-material/AssignmentTurnedIn';
//api
import { getContractorsRequest } from "../../api/contractors";
import {getUserProfileRequest} from "../../api/users";
import {approveContractorRequest} from "../../api/contractors";
import {rejectContractorRequest} from "../../api/contractors";
//Hooks
import { useEffect, useState,useContext } from "react";
import { useTranslation } from "react-i18next";
//Components
import Profiledialog from "../../components/Profiledialog/Profiledialog";
import Confirmdialog from "../../components/Confirmdialog/Confirmdialog";
import Snackbar from "../../components/Snackbar/Snakbar";
import Imagedialog from "../../components/Imagedialog/Imagedialog";
//Libraries
import dayjs from "dayjs";

export default function Requests() {
    const [t] = useTranslation();
    const [contractors, setContractors] = useState([]);
    const [profileload,setprofileload] = useState(false);
    const [contractorinfo,setcontractorinfo] = useState({});
    const [msg,setmsg] = useState();
    const [showprofile, setshowprofile] = useState(false);
    const [showconfirmdialog, setshowconfirmdialog] = useState(false);
    const [showrejectdialog, setshowrejectdialog] = useState(false);
    const [isopen, setisopen] = useState(false);
    const [selectedUserId, setSelectedUserId] = useState(null);
    const [openimage,setopenimage] = useState(false);
    const [selectedImage, setSelectedImage] = useState("");
    const {setisloading}=useContext(LoadingContext);
    let status = {"pending":"قيد الانتظار","approved":"مقبول","rejected":"مرفوض"}
    let role ={ 1:t("مدير النظام"), 2:t("مستخدم"), 3:t("متعهد"), 4:t("مهندس")}
    //Requests
    async function getContractors() {
        setisloading(true);
        await new Promise(resolve => setTimeout(resolve, 1500));
        try{
            let response = await getContractorsRequest();
            setContractors(response.data);
        }finally{
            setisloading(false);
            }
        }
    async function showContractor(id) {
            setprofileload(true);
            setcontractorinfo({});    
            let response = await getUserProfileRequest(id);
            setcontractorinfo(response.data.data);
            setprofileload(false); 
    }
    async function approveContractor(id) {
            setprofileload(true);
            let response = await approveContractorRequest(id);
            setmsg(response.data.message);
            setprofileload(false);
            await getContractors();
            setisopen(true);
           
    }
    async function rejectContractor(id) {
            setprofileload(true);
            try{
            let response = await rejectContractorRequest(id);
            setmsg(response.data.message);
            }catch(error){
                console.log(error);
            }
            setprofileload(false);
            await getContractors();
            setisopen(true);
           
    }
    useEffect(() => {getContractors();}, []);
    return (
        <div>
        {profileload ? (<div className="page"></div>):(
            showprofile && (<Profiledialog
         name={contractorinfo?.name}
         first_name={contractorinfo?.contractor_profile?.first_name}
         last_name={contractorinfo?.contractor_profile?.last_name}
         image={contractorinfo?.contractor_profile?.full_image_url ? <Avatar  src={contractorinfo?.contractor_profile?.full_image_url} alt="img" sx={{ width: 80, height: 80 }} /> :<AccountCircleIcon  sx={{ color: '#f07c1f' ,fontSize:"80px" }} />}
         email={contractorinfo?.email}
         phone={contractorinfo?.contractor_profile?.phone}
         location={contractorinfo?.contractor_profile?.location}
         role={role[contractorinfo?.role_id]}
         children={
         <div className="img-field">
            <span className="label">{t("الصور")}</span>
            <div className="cert-thumb" onClick={(e) =>{
                e.stopPropagation();
                setSelectedImage(contractorinfo?.contractor_profile?.full_commercial_record_url);
                setopenimage(true)
            }}><img src={contractorinfo?.contractor_profile?.full_commercial_record_url} alt="Commercial Record" /></div>
        </div>}
         onClose={() => setshowprofile(false)}
          />)
        )}
        {showconfirmdialog && (<Confirmdialog
         icon={<PersonAddIcon sx={{ color: "#f07c1f" ,fontSize:65 }}/>}
         title={t("تأكيد القبول")}
         message={t("هل تريد قبول هذا المستخدم؟")}
         name_btn1={t("إلغاء")}
         name_btn2={t("قبول")}
         btnColor={"#f07c1f"}
         onClose={() => setshowconfirmdialog(false)}
         onConfirm={() => {approveContractor(selectedUserId);}}
        />)}
        {showrejectdialog && (<Confirmdialog
         icon={<CloseIcon sx={{ color: "#e53935" ,fontSize:65 }}/>}
         title={t("تأكيد الرفض")}
         message={t("هل تريد رفض هذا المستخدم؟")}
         name_btn1={t("إلغاء")}
         name_btn2={t("رفض")}
         btnColor={"#e53935"}
         onClose={() => setshowrejectdialog(false)}
         onConfirm={() => {rejectContractor(selectedUserId);}}
        />)}
        {openimage && (<Imagedialog
         src={selectedImage}
         onClose={() => setopenimage(false)}
        />)}
        <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity="success"/>
        <div className="contractor-list">
            <div className="contractor-header">
                <h3><AssignmentTurnedInIcon sx={{color: "#f07c1f"}}/> {t("طلبات المتعهدين")}</h3>
                <div className="list-actions">
                    <button className="btn-refresh" onClick={getContractors}><RefreshIcon sx={{fontSize: "18px"}}/> {t("تحديث")}</button>
                </div>
            </div>
        {contractors.length === 0 ? <div className="no-requests">لا يوجد طلبات</div> :
        contractors.map((contractor) => (
            <div className="request-card" key={contractor.id}>
            <div className="card-avatar">
                {contractor?.contractor_profile?.full_image_url ?<Avatar  src={contractor?.contractor_profile?.full_image_url} alt="img" sx={{ width: 75, height: 75 }} />: <Avatar   sx={{ width: 75, height: 75 , color: "#f07c1f", backgroundColor: "rgba(240, 124, 31, 0.1)"}} />}
                <span className="status">{t(status[contractor.status])}</span>
            </div>

            <div className="card-info">
                <div className="name">{contractor?.contractor_profile?.first_name + " " + contractor?.contractor_profile?.last_name}</div>
                <div className="company"><ApartmentIcon sx={{ color: "#f07c1f" , fontSize: 19}} />{contractor?.contractor_profile?.company_name}</div>
                <div className="details">
                    <span><EmailIcon sx={{ color: "#f07c1f" , fontSize: 18}} />{contractor?.email}</span>
                    <span><LocalPhoneIcon sx={{ color: "#f07c1f" , fontSize: 18}} />{contractor?.contractor_profile?.phone}</span>
                    <span><LocationOnIcon sx={{ color: "#f07c1f" , fontSize: 18}} /> {contractor?.contractor_profile?.location}</span>
                    <span><CalendarMonthIcon sx={{ color: "#f07c1f" , fontSize: 18}} /> {dayjs(contractor?.contractor_profile?.created_at).format("YYYY-MM-DD")}</span>
                </div>
                <div className="card-certs">
                    <div className="cert-thumb" 
                        onClick={()=>{
                            setSelectedImage(contractor?.contractor_profile?.full_commercial_record_url);
                            setopenimage(true);}}>
                            <img src={contractor?.contractor_profile?.full_commercial_record_url} alt="" /></div>
                </div>
            </div>
            <div className="card-actions">
                <button className="btn-view" onClick={() =>{setshowprofile(true);showContractor(contractor.id)} }><VisibilityIcon sx={{  fontSize: 18}} />{t("عرض")}</button>
                <button className="btn-approve" onClick={() =>{setSelectedUserId(contractor.id);setshowconfirmdialog(true);} }><CheckIcon sx={{  fontSize: 18}} /> {t("قبول")}</button>
                <button className="btn-reject" onClick={() =>{setSelectedUserId(contractor.id);setshowrejectdialog(true);} }><CloseIcon sx={{  fontSize: 18}} /> {t("رفض")}</button>
            </div>
        </div>

        ))
        }
        
        
        </div>
        </div>
    )
}