import "./Projectsarchive.css";
//Hooks
import { useTranslation } from 'react-i18next';
import { useState , useEffect , useContext } from "react";
// MUI 
import ApartmentIcon from '@mui/icons-material/Apartment';
import RefreshIcon from '@mui/icons-material/Refresh';
import VisibilityIcon from '@mui/icons-material/Visibility';
import LocationOnIcon from '@mui/icons-material/LocationOn';
import ArchiveIcon from '@mui/icons-material/Archive';
import UnarchiveIcon from '@mui/icons-material/Unarchive';
//api
import {showProjectRequest} from "../../api/projects";
import {getArchivedProjectsRequest} from "../../api/projects";
import {restoreProjectRequest} from "../../api/projects";
import {showArchivedProjectRequest} from "../../api/projects";
//Context
import { LoadingContext } from "../../Context/Loadingcontext";
//Component
import Norequest from "../../components/Norequest/Norequest";
import TablePagination from "../../components/Pagination/Pagination";
import Button from "../../components/Button/Button";
import IconBtn from "../../components/IconBtn/IconBtn";
import Projectdialog from "../../components/Projectdialog/Projectdialog";
import Confirmdialog from "../../components/Confirmdialog/Confirmdialog";
import Snackbar from "../../components/Snackbar/Snakbar";



export default function Projectsarchive() {
    const [t]=useTranslation();
    const {setisloading}=useContext(LoadingContext);
    const [projects,setprojects]=useState([]);
    const [archivedproject,setarchivedproject]=useState({});
    const [page, setPage] = useState(1);
    const [showprojectdialog,setshowprojectdialog]=useState(false);
    const [profileload,setprofileload] = useState(false);
    const [selectedproject,setselectedproject]=useState(null)
    const [showrestoredialog,setshowrestoredialog]=useState(false);
    const [isopen, setisopen] = useState(false);
    const [severity, setseverity] = useState("");
    const [msg, setmsg] = useState("");
    const rowsPerPage = 12;
    const paginatedProjects = projects.slice((page - 1) * rowsPerPage , page * rowsPerPage);
    let type={restoration:t("ترميم") , construction:t("بناء") , finishing:t("إكساء")};
    let status={active:t("نشط"), completed:t("مكتمل"), cancelled:t("ملغي")}
    //Request
    async function getArchivedProjects() {
        setisloading(true);
        let response = await getArchivedProjectsRequest();
        await setprojects(response.data.data);
        setisloading(false);
    }
    async function showArchivedProject(id) {
        try {
            setprofileload(true);
            const response = await showArchivedProjectRequest(id);
            setarchivedproject(response.data.data);
            setshowprojectdialog(true);
        } catch (error) {
            console.log("ERROR:", error);
        } finally {
            setprofileload(false);
        }
    }
    async function restoreArchivedProject(id){
        setshowrestoredialog(false);
        setprofileload(true);
        try{
         await restoreProjectRequest(id);
         setmsg(t("تم استعادة المشروع بنجاح"));
         setseverity("success");
         await getArchivedProjects();
        }catch(error){
         console.log(error);
        }finally{
         setisopen(true);
         setprofileload(false);      
        }    
    }
    useEffect(() => {
        getArchivedProjects();
    }, []);
    return(
    <>
        {profileload ? (<div className="page"></div>):(
        showprojectdialog && <Projectdialog
            onClose={() => setshowprojectdialog(false)}
            id={archivedproject?.id}
            pr_name={archivedproject?.form?.reconstruction_request?.title}
            pr_type={archivedproject?.form?.reconstruction_request?.type}
            status={archivedproject?.status}
            progress={archivedproject?.progress}
            execution_duration={archivedproject?.form?.execution_duration}
            warranty_period={archivedproject?.form?.warranty_period}
            date={archivedproject?.created_at}
            description={archivedproject?.form?.reconstruction_request?.description}
            user_name={archivedproject?.user?.name}
            user_email={archivedproject?.user?.email}
            user_phone={archivedproject?.user?.profile?.phone}
            user_address={archivedproject?.user?.profile?.location}
            eng_name={archivedproject?.engineer?.name}
            eng_email={archivedproject?.engineer?.email}
            eng_phone={archivedproject?.engineer?.engineer_profile?.phone}
            eng_address={archivedproject?.engineer?.engineer_profile?.location}
            cons_name={archivedproject?.contractor?.name}
            cons_email={archivedproject?.contractor?.email}
            cons_phone={archivedproject?.contractor?.contractor_profile?.phone}
            cons_address={archivedproject?.contractor?.contractor_profile?.location}
            materials_cost={archivedproject?.form?.materials_cost}
            labor_cost={archivedproject?.form?.labor_cost}
            profit={archivedproject?.form?.profit}
            total_cost={archivedproject?.form?.total_cost}
            tasks={archivedproject?.tasks || []}
        />
        )}
        {showrestoredialog && (<Confirmdialog
        icon={<UnarchiveIcon sx={{ color: "#f07c1f" ,fontSize:65 }}/>}
         title={t("تأكيد الاستعادة")}
         message={t("هل تريد استعادة هذا المشروع")}
         name_btn1={t("إلغاء")}
         btnColor={"#f07c1f"}
         name_btn2={t("استعادة")}
         onClose={() => setshowrestoredialog(false)}
         onConfirm={() => {restoreArchivedProject(selectedproject)}}
        />)}
        <Snackbar msg={msg} isopen={isopen} setisopen={setisopen} severity={severity}/>
        <div class="table-body">
            <div class="table-header">
                <h3><ApartmentIcon sx={{ color: "#f07c1f" , fontSize: "28px"}}/> {t("المشاريع المؤرشفة")}</h3>
                <div className="table-actions">
                    <Button className="refresh" onClick={() => {getArchivedProjects();setPage(1)}} icon={<RefreshIcon sx={{fontSize: "18px"}}/>} text="تحديث"/>
                </div>
            </div>
            {projects.length===0?(<Norequest text="لا يوجد مشاريع مؤرشفة"/>):(
            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>{t("رقم")}</th>
                            <th>{t("اسم المشروع")}</th>
                            <th>{t("النوع")}</th>
                            <th>{t("الموقع")}</th>
                            <th>{t("صاحب المشروع")}</th>
                            <th>{t("المتعهد")}</th>
                            <th>{t("المهندس")}</th>
                            <th>{t("نسبة الإنجاز")}</th>
                            <th>{t("الحالة")}</th>
                            <th>{t("الإجراءات")}</th>
                        </tr>
                    </thead>
                <tbody>
                    {paginatedProjects.map((project) => (
                        <tr key={project?.id}>
                        <td>#{project?.id}</td>
                        <td>{project?.form?.reconstruction_request?.title}</td>
                        <td>{type[project?.form?.reconstruction_request?.type]}</td>
                        <td><div className="location"><LocationOnIcon sx={{ color: "#f07c1f"}}/>{project?.form?.reconstruction_request?.location}</div></td>
                        <td>{project?.user?.name}</td>
                        <td>{project?.contractor?.name}</td>
                        <td>{project?.engineer?.name}</td>
                        <td>
                            <div className="progress">
                            <div className="progress-bar">
                                <div className="progress-fill" style={{ width: `${project?.progress}%` }}></div>
                            </div>
                            <span>{project?.progress}%</span>
                            </div>
                        </td>                        
                        <td><div className={`type ${project?.status}`}>{status[project?.status]}</div></td>
                        <td>
                            <div className="actions">
                                <IconBtn name="عرض" clr="#2196f3" bgc="rgba(33,150,243,0.1)" h_clr="white" h_bgc="#2196f3" onClick={() =>{showArchivedProject(project?.id);}} icon={<VisibilityIcon sx={{ fontSize: 24 }} />} />
                                <IconBtn name={"إستعادة"} clr={"#FF9800"} bgc={"rgba(255,152,0,0.1)"} h_clr={"white"} h_bgc={"#FF9800"} icon={<UnarchiveIcon sx={{fontSize: 24}}/>} onClick={()=>{setselectedproject(project?.id);setshowrestoredialog(true)}}/> 
                            </div>
                                                   
                        </td>
                        </tr>
                    ))}
                    </tbody>
                </table>
            </div>
            )}
            <div className="table-footer">
                    <TablePagination
                        count={Math.ceil(projects.length / rowsPerPage)}
                        page={page}
                        onChange={(event,value)=>setPage(value)}
                    />
            </div>            
        </div>        
    </>
    )
}