import "./Complaints.css";
import "../Users/Table.css";
//MUI Icons
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import RefreshIcon from '@mui/icons-material/Refresh';
import VisibilityIcon from '@mui/icons-material/Visibility';
import FeedbackIcon from '@mui/icons-material/Feedback';
import ArchiveIcon from '@mui/icons-material/Archive';
import CloseIcon from '@mui/icons-material/Close';
import DoneIcon from '@mui/icons-material/Done';
import WarningIcon from '@mui/icons-material/Warning';
import PersonIcon from '@mui/icons-material/Person';
//api
import {getComplaintsRequest} from "../../api/complaints"
import {getFilterComplaintsRequest} from "../../api/complaints"
import {patchComplaintRequest} from "../../api/complaints";
import {archiveComplaintsRequest} from "../../api/complaints";
import {getComplaintDetailsRequest} from "../../api/complaints";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//Components
import TablePagination from "../../components/Pagination/Pagination";
import Filterdialog from "../../components/Filterdialog/Filterdialog";
import Confirmdialog from "../../components/Confirmdialog/Confirmdialog";
import Snackbar from "../../components/Snackbar/Snakbar";
import Complainthandlingdialog from "../../components/Complainthandlingdialog/Complainthandlingdialog";
import Complaintdetailsdialog from "../../components/Complaintdetailsdialog/Complaintdetailsdialog";
import IconBtn from "../../components/IconBtn/IconBtn";
import Button from "../../components/Button/Button";
import Norequest from "../../components/Norequest/Norequest";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Libraries
import dayjs from "dayjs";

export default function Complaints() {
    const {t}=useTranslation();
    const {setisloading}=useContext(LoadingContext);
    const [complaintsList,setComplaintsList]=useState([]);
    const [selectedComplaint, setSelectedComplaint] = useState(null);
    const [showconfirmdialog, setshowconfirmdialog] = useState(false);
    const [isopen, setisopen] = useState(false);
    const [severity, setseverity] = useState("");
    const [msg, setmsg] = useState("");
    const [profileload,setprofileload] = useState(false);
    const [page, setPage] = useState(1);
    const [showfilterdialog,setshowfilterdialog] = useState(false);
    const [selectedFilters,setSelectedFilters]=useState({type:"",complained_on_role:""});
    const [showresolvedialog, setshowresolvedialog] = useState(false);
    const [showarchivedialog, setshowarchivedialog] = useState(false);
    const [showcomplaintsdialog, setshowcomplaintsdialog] = useState(false);
    const [complaintdetails,setcomplaintdetails] = useState({});
    const rowsPerPage = 12;
    const paginatedComplaints = complaintsList.slice((page - 1) * rowsPerPage , page * rowsPerPage);
    let role = { 2:t("المستخدم"), 3:t("المتعهد"), 4:t("المهندس")}
    let type = { no_show:t("عدم الحضور"),general:t("عامة")}
    let status = { open:t("مفتوحة"), resolved:t("تمت المعالجة"), dismissed:t("مرفوضة") }
    let FilterComplaints = [
        {
            subtitle: "نوع الشكوى",
            icon: <FeedbackIcon sx={{ color: "#f07c1f",fontSize:20 }} />,
            name: "type",
            options: [
            { value: "", label: "الكل"},
            { value: "general", label: "عامة"},
            { value: "no_show", label: "عدم الحضور"},
            ],
        },{
            subtitle: "نوع المشكي عليه",
            icon: <PersonIcon sx={{ color: "#f07c1f",fontSize:20 }} />,
            name: "complained_on_role",
            options: [
            { value: "", label: "الكل"},
            { value: "contractor", label: "متعهد"},
            { value: "engineer", label: "مهندس"},
            { value: "user", label: "مستخدم"},
            ],
        },
    ]
    //Requests
    async function getComplaintsList(){
        setisloading(true);
        try{
            let response=await getComplaintsRequest();
            setComplaintsList(response.data.data);
        }catch(error){
            console.log(error);
        }finally{
            setisloading(false);
        }
    }
    async function getFilterComplaints(filters) {
        setshowfilterdialog(false);
        setisloading(true);
        await new Promise(resolve => setTimeout(resolve, 1500));
        try{       
    
                let response = await getFilterComplaintsRequest(filters);
                setComplaintsList(response.data.data);
                setPage(1);
            }finally{
                setisloading(false);
             }

    }   
    async function dismissComplaint(id,status,admin_processing_note,penalty_percentage){
       setshowconfirmdialog(false);
       setprofileload(true);
       try{
        let response = await patchComplaintRequest(id,status,admin_processing_note,penalty_percentage);
        setmsg(response.data.message);
        setseverity("success");
        await getComplaintsList();
       }catch(error){
        console.log(error);
       }finally{
        setisopen(true);
        setprofileload(false);      
       }
    }
    async function resolveComplaint(id,status,admin_processing_note,penalty_percentage=""){
        setshowresolvedialog(false);
        setprofileload(true);
        try{
         let response = await patchComplaintRequest(id,status,admin_processing_note,penalty_percentage);
         setmsg(response.data.message);
         setseverity("success");
         await getComplaintsList();
        }catch(error){
         console.log(error);
        }finally{
         setisopen(true);
         setprofileload(false);      
        }
    }
    async function archiveComplaint(type,id){
        setshowarchivedialog(false);
        setprofileload(true);
        try{
         await archiveComplaintsRequest(type,id);
         setmsg(t("تم ارشفة الشكوى بنجاح"));
         setseverity("success");
         await getComplaintsList();
        }catch(error){
         console.log(error);
        }finally{
         setisopen(true);
         setprofileload(false);      
        }
    }
    async function getComplaintDetails(type,id){
        setprofileload(true);
        setcomplaintdetails({});    
        let response = await getComplaintDetailsRequest(type,id);
        setcomplaintdetails(response.data.data);
        setprofileload(false);
    }
    useEffect(()=>{getComplaintsList();},[]);
    return(
        <div>
        {showfilterdialog && (<Filterdialog
         groups={FilterComplaints} 
         title={"فلترة الشكاوى"} 
         onClose={() => setshowfilterdialog(false)} 
         onApply={getFilterComplaints}
         selectedFilters={selectedFilters}
         setSelectedFilters={setSelectedFilters}
         onReset={()=>{setSelectedFilters({type:"",complained_on_role:""})}}
         />)}
        {showconfirmdialog && (<Confirmdialog
         icon={<WarningIcon sx={{ color: "#e53935" ,fontSize:65 }}/>}
         title={t("تأكيد الرفض")}
         message={t("هل تريد رفض هذه الشكوى؟")}
         name_btn1={t("إلغاء")}
         btnColor={"#e53935"}
         name_btn2={t("رفض")}
         onClose={() => setshowconfirmdialog(false)}
         onConfirm={() => dismissComplaint(selectedComplaint?.id,"dismissed","","")}
        />)}
        {showresolvedialog && (<Complainthandlingdialog
        id={selectedComplaint?.id}
        complainant_name={selectedComplaint?.complainant?.name}
        complainton_name={selectedComplaint?.complained_on?.name}
        onApply={(data) => {resolveComplaint(selectedComplaint?.id,"resolved",data.admin_processing_note,data.penalty_percentage)}}
        onClose={() => setshowresolvedialog(false)}
        />)}
        {showarchivedialog && (<Confirmdialog
        icon={<ArchiveIcon sx={{ color: "#f07c1f" ,fontSize:65 }}/>}
         title={t("تأكيد الأرشفة")}
         message={t("هل تريد أرشفة هذه الشكوى؟")}
         name_btn1={t("إلغاء")}
         btnColor={"#f07c1f"}
         name_btn2={t("أرشفة")}
         onClose={() => setshowarchivedialog(false)}
         onConfirm={() => {
            if(selectedComplaint?.type==="no_show"){
                archiveComplaint("no-show-warnings",selectedComplaint?.id)
            }else{
                archiveComplaint("complaints",selectedComplaint?.id)
            }
         }}
        />)}
        {profileload ? (<div className="page"></div>):(
            showcomplaintsdialog && (<Complaintdetailsdialog
        onClose={() => setshowcomplaintsdialog(false)}
        id={complaintdetails?.id}
        status={complaintdetails?.status}
        type={complaintdetails?.type}
        title={complaintdetails?.reason}
        description={complaintdetails?.description}
        date={complaintdetails?.created_at}
        complaint_img={complaintdetails?.complainant?.profile?.full_image_url}
        complaint_n={complaintdetails?.complainant?.profile?.first_name + " " +complaintdetails?.complainant?.profile?.last_name}
        complaint_r={complaintdetails?.complainant?.role_id}
        complaint_p={complaintdetails?.complainant?.profile?.phone}
        complaint_e={complaintdetails?.complainant?.email}
        complaint_l={complaintdetails?.complainant?.profile?.location}
        complainton_img={complaintdetails?.complained_on?.profile?.full_image_url}
        complainton_n={complaintdetails?.complained_on?.profile?.first_name + " " +complaintdetails?.complained_on?.profile?.last_name}
        complainton_r={complaintdetails?.complained_on?.role_id}
        complainton_p={complaintdetails?.complained_on?.profile?.phone}
        complainton_e={complaintdetails?.complained_on?.email}
        complainton_l={complaintdetails?.complained_on?.profile?.location}
        complainton_c={complaintdetails?.complained_on?.complaints_count}
        p_title={complaintdetails?.construction_form?.reconstruction_request?.title}
        p_type={complaintdetails?.construction_form?.reconstruction_request?.type}
        p_location={complaintdetails?.construction_form?.reconstruction_request?.location}
        p_status={complaintdetails?.construction_form?.reconstruction_request?.status}
        images={complaintdetails?.images}
        admin_note={complaintdetails?.admin_processing_note}
        penalty_percentage={complaintdetails?.penalty_percentage}
        penalty_amount={complaintdetails?.penalty_amount}
        resolved_at={complaintdetails?.resolved_at}
        is_archived={complaintdetails?.is_archived}
        archived_at={complaintdetails?.archived_at}
        />
        ))}
        {profileload && (<div className="page"></div>)}
            <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={severity}/>
        
            <div className="table-body">
            <div className="table-header">
                <h3><FeedbackIcon sx={{ color: "#f07c1f" , fontSize:23}}/> {t("شكاوى المستخدمين")}</h3>
                <div className="table-actions">
                    <Button className="filter" onClick={() => setshowfilterdialog(true)} icon={<FilterAltIcon sx={{fontSize: "18px"}}/>} text={"فلترة"}/>
                    <Button className="refresh" onClick={()=>{getComplaintsList();setPage(1);}} icon={<RefreshIcon sx={{fontSize: "18px"}}/>} text={"تحديث"}/>
                </div>
            </div>
            {complaintsList.length===0?(<Norequest text="لا يوجد شكاوى"/>):(
            <div className="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>{t("الرقم")}</th>
                            <th>{t("مقدم الشكوى")}</th>
                            <th>{t("المشكي عليه")}</th>
                            <th>{t("الشكوى")}</th>
                            <th>{t("نوع الشكوى")}</th>
                            <th>{t("تاريخ الشكوى")}</th>
                            <th>{t("حالة الشكوى")}</th>
                            <th>{t("عدد الشكاوى")}</th>
                            <th>{t("الاجراءات")}</th>
                        </tr>
                    </thead>
                   <tbody>
                    {paginatedComplaints.map((complaint) => {
                        return(<tr key={complaint?.id}>
                        <td>{complaint?.id}</td>
                        <td>{role[complaint?.complainant_role_id]} :{complaint?.complainant.name}</td>
                        <td>{role[complaint?.complained_on_role_id]} :{complaint?.complained_on.name}</td>
                        <td>{complaint?.reason}</td>
                        <td>{type[complaint?.type]}</td>
                        <td>{dayjs(complaint?.created_at).format("YYYY-MM-DD")}</td>
                        <td>{complaint.status?status[complaint?.status]:t("تمت المعالجة تلقائياً")}</td>
                        <td>{complaint?.complained_on.complaints_count}</td>
                        <td>
                            <div className="actions">
                            <IconBtn name={"عرض"} clr={"#2196f3"} bgc={"rgba(33,150,243,0.1)"} h_clr={"white"} h_bgc={"#2196f3"} icon={<VisibilityIcon sx={{fontSize: 24}}/>} className="complaints-action-btn"
                             onClick={()=>{
                                        setSelectedComplaint(complaint);
                                        if(complaint?.type==="general"){
                                            getComplaintDetails("complaints",complaint?.id);
                                        }else{
                                            getComplaintDetails("no-show-warnings",complaint?.id);
                                        }
                                        setshowcomplaintsdialog(true);}}/>
                            {complaint.status==="open"?(
                                <>
                                <IconBtn name={"قبول الشكوى"} clr={"#4CAF50"} bgc={"rgba(76,175,80,0.1)"} h_clr={"white"} h_bgc={"#4CAF50"} icon={<DoneIcon sx={{fontSize: 24}}/>} onClick={()=>{setSelectedComplaint(complaint);setshowresolvedialog(true)}}/>
                                <IconBtn name={"رفض الشكوى"} clr={"#e53935"} bgc={"rgba(229,57,53,0.1)"} h_clr={"white"} h_bgc={"#e53935"} icon={<CloseIcon sx={{fontSize: 24}}/>} onClick={()=>{setSelectedComplaint(complaint);setshowconfirmdialog(true);}}/>
                                </>
                            ):(<></>)}
                            {(complaint.status==="resolved"||complaint.status==="dismissed"||!complaint.status)?(
                                <IconBtn name={"أرشفة"} clr={"#FF9800"} bgc={"rgba(255,152,0,0.1)"} h_clr={"white"} h_bgc={"#FF9800"} icon={<ArchiveIcon sx={{fontSize: 24}}/>} onClick={()=>{setSelectedComplaint(complaint);setshowarchivedialog(true)}}/>
                            ):(<></>)}
                            </div>
                        </td>
                        </tr>)
                        
                    })}
                    </tbody>
                </table>
            </div>
            )}
            <div className="table-footer">
                    <TablePagination
                      count={Math.ceil(complaintsList.length / rowsPerPage)}
                      page={page}
                      onChange={(event,value)=>setPage(value)}
                    />
            </div>
        </div>
        
        </div>
    )
}