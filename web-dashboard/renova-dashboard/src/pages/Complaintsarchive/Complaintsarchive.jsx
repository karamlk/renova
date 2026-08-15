import "./Complaintsarchive.css";
//MUI Icons
import FilterAltIcon from '@mui/icons-material/FilterAlt';
import RefreshIcon from '@mui/icons-material/Refresh';
import VisibilityIcon from '@mui/icons-material/Visibility';
import FeedbackIcon from '@mui/icons-material/Feedback';
import PersonIcon from '@mui/icons-material/Person';
import ModeCommentIcon from '@mui/icons-material/ModeComment';

//api
import {getComplaintsArchiveRequest} from "../../api/complaints"
import {getFilterComplaintsRequest} from "../../api/complaints"
import {getComplaintDetailsRequest} from "../../api/complaints";

//Hooks
import { useTranslation } from 'react-i18next';
import { useState,useEffect,useContext } from "react";
//Components
import TablePagination from "../../components/Pagination/Pagination";
import Filterdialog from "../../components/Filterdialog/Filterdialog";
import Complaintdetailsdialog from "../../components/Complaintdetailsdialog/Complaintdetailsdialog";
import IconBtn from "../../components/IconBtn/IconBtn";
import Button from "../../components/Button/Button";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Libraries
import dayjs from "dayjs";

export default function Complaintsarchive() {
    const {t}=useTranslation();
    const {setisloading}=useContext(LoadingContext);
    const [complaintsList,setComplaintsList]=useState([]);
    const [page, setPage] = useState(1);
    const [showfilterdialog,setshowfilterdialog] = useState(false);
    const [selectedFilters,setSelectedFilters]=useState({type:"",complained_on_role:""});
    const [profileload,setprofileload] = useState(false);
    const [showcomplaintsdialog, setshowcomplaintsdialog] = useState(false);
    const [complaintdetails,setcomplaintdetails] = useState({});
    const [selectedComplaint, setSelectedComplaint] = useState(null);
    
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
    async function getComplaintsArchiveList(){
        setisloading(true);
        try{
            let response=await getComplaintsArchiveRequest();
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
    async function getComplaintDetails(type,id){
        setprofileload(true);
        setcomplaintdetails({});    
        let response = await getComplaintDetailsRequest(type,id);
        setcomplaintdetails(response.data.data);
        setprofileload(false);
    }    
    useEffect(()=>{getComplaintsArchiveList();},[]);
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
            <div className="complaints-table">
            <div className="complaints-table-header">
                <h3><ModeCommentIcon sx={{ color: "#f07c1f" , fontSize:23}}/> {t("أرشيف الشكاوى")}</h3>
                <div className="complaints-table-actions">
                    <Button className="filter" onClick={() => setshowfilterdialog(true)} icon={<FilterAltIcon sx={{fontSize: "18px"}}/>} text={"فلترة"}/>
                    <Button className="refresh" onClick={()=>{getComplaintsArchiveList();setPage(1);}} icon={<RefreshIcon sx={{fontSize: "18px"}}/>} text={"تحديث"}/>
                </div>
            </div>
            {complaintsList.length===0?(<div className="no-requests">لاتوجد شكاوى مؤرشفة</div>):(
            <div className="complaints-table-container">
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
                            <div className="complaints-actions">
                                <IconBtn name="عرض" clr="#2196f3" bgc="rgba(33,150,243,0.1)" h_clr="white" h_bgc="#2196f3"  icon={<VisibilityIcon sx={{ fontSize: 24 }} />} 
                                    onClick={()=>{
                                        setSelectedComplaint(complaint);
                                        if(complaint?.type==="general"){
                                            getComplaintDetails("complaints",complaint?.id);
                                        }else{
                                            getComplaintDetails("no-show-warnings",complaint?.id);
                                        }
                                        setshowcomplaintsdialog(true);
                                    }} />
                            </div>
                        </td>
                        </tr>)
                        
                    })}
                    </tbody>
                </table>
            </div>
            )}
            <div className="complaints-table-footer">
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